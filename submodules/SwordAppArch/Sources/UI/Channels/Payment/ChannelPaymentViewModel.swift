//
//  ChannelPaymentViewModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 26.12.22.
//

import UIKit
import Combine
import TelegramCore
import AccountContext

public struct ChannelPaymentViewModelInputs {
    let downloadManager: DataDownloadManaging
    let accountsBalanceService: AccountsBalanceServicing
    let getCryptoAssetsService: GetCryptoAssetsServicing
    let makePaymentService: MakePaymentServicing
    let assetsPricesChangesService: AssetsPricesChangesServicing
}

public final class ChannelPaymentViewModel: BaseViewModel<ChannelPaymentViewModelInputs>, StackViewModeling {
    private let amountValidator: CurrentValueSubject<Bool, Never> = CurrentValueSubject(false)
    private var sectionHeaderModel = ChannelPaymentSectionHeaderViewModel()

    public var setupModel: CurrentValueSubject<ChannelPaymentStackViewModel?, Never> = .init(nil)

    let emptyStateViewModel = ChannelPaymentEmptyStateViewModel()

    var emptyStateReason: EmptyStateReason? = nil
    let stateInfo: PayOrRequestStateInfoModel
    lazy var footerSetupModel: ChannelPaymentFooterViewModel = {
        let model = ChannelPaymentFooterViewModel(isPaying: !stateInfo.isRequesting)
        
        model.isSendActionAvailable = stateInfo.isSendActionAvailable
        
        return model
    }()
    
    let paymentCompletion: PassthroughSubject<Void, Never> = .init()
    var redirectURLPublisher: PassthroughSubject<String, Never> = .init()
    let cryptoPickerPublisher: PassthroughSubject<Void, Never> = PassthroughSubject()
    let amountTypePickerPublishers: PassthroughSubject<Void, Never> = PassthroughSubject()
    let channelParticipantsPresenterPublisher: PassthroughSubject<Void, Never> = PassthroughSubject()
    let addNewParticipantsPublisher: PassthroughSubject<Void, Never> = PassthroughSubject()
    let cryptoAccountUpdatePublisher: PassthroughSubject<UnavailableCryptoReason, Never> = PassthroughSubject()
    
    let transactionButtonHandler: PassthroughSubject<Bool, Never> = .init()
    let customButtonHandler: PassthroughSubject<Void, Never> = .init()
    
    var accountRedirectURL: String?

    var redirectingSource: RedirectingSource? = nil
    var allAssetsResponse: GetCryptoAssetsResponse?

    var mainCoin: String? {
        return setupModel.value?.headerModel.accountsBalanceInfo.mainCoin
    }

    var previousSelectedCoin: String?
    var assetsPrices: [AssetsPricesOnMainCoinResponse] = [] {
        didSet {
            self.setupModel.value?.headerModel.assetsPrices = assetsPrices
            prepareAmount()
        }
    }
    var mainCoinPriceInEuro: Double? {
        didSet {
            self.setupModel.value?.headerModel.mainCoinPriceInEuro = mainCoinPriceInEuro
            prepareAmount()
        }
    }
    var tradeDataPublisher: PassthroughSubject<Any, Never> = .init()
    var tickerDataPublisher: PassthroughSubject<Any, Never> = .init()

    let validationAlertErrorMessagePublisher: PassthroughSubject<String, Never> = PassthroughSubject()
    let minimumAmountErrorPublisher: PassthroughSubject<Double, Never> = PassthroughSubject()
    let topUpAlertPublisher: PassthroughSubject<Void, Never> = PassthroughSubject()
    
    lazy var membersInfoHolderViewModel: ChannelPaymentParticipantsViewModel = {
        return .init(title: "", participants: [])
    }()

    let context: AccountContext
    
    init(inputs: ChannelPaymentViewModelInputs,
         stateInfo: PayOrRequestStateInfoModel,
         context: AccountContext) {

        self.context = context
        self.stateInfo = stateInfo

        super.init(inputs: inputs)

        bindToSocketConnection()
        bindToActionButtonState()
        bindToCryptoPricesChanges()
        bindToFooterActionsPublisher()
    }
    
    func fetchAccountBalance() {
        guard let balanceResponse = CryptoCacher.global.balanceResponse else {
            
            let route = AccountsBalanceParams()

            isLoading.send(true)
            
            if stateInfo.isRequesting {
                inputs.accountsBalanceService.fetch(route: route)
                    .combineLatest(inputs.getCryptoAssetsService.fetch(route: .init()))
                    .receive(on: RunLoop.main)
                    .sink { [ weak self ] completion in
                        self?.handleSubscriptionCompletion(completion)
                    } receiveValue: { [ weak self ] balanceResponse, assetsResponse in
                        self?.prepareMainCoinConvertableCryptos(balanceResponse: balanceResponse.data,
                                                                assetsResponse: assetsResponse.data)
                    }
                    .store(in: &cancellables)
            } else {
                inputs.accountsBalanceService.fetch(route: route)
                    .receive(on: RunLoop.main)
                    .sink { [ weak self ] completion in
                        self?.handleSubscriptionCompletion(completion)
                    } receiveValue: { [ weak self ] balanceResponse in
                        self?.prepareMainCoinConvertableCryptos(balanceResponse: balanceResponse.data,
                                                                assetsResponse: nil)
                    }
                    .store(in: &cancellables)
            }

            return
        }
        
        isLoading.send(true)
        prepareMainCoinConvertableCryptos(balanceResponse: balanceResponse,
                                          assetsResponse: CryptoCacher.global.assetsResponse)
    }
    
    private func prepareMainCoinConvertableCryptos(balanceResponse: AccountsBalanceResponse,
                                                   assetsResponse: GetCryptoAssetsResponse?) {
        guard balanceResponse.redirectUrl == nil else {
            isLoading.send(false)
            handleAccountInfoFetching(balanceResponse: balanceResponse, assetsResponse: assetsResponse, doesHaveCryptoInfo: true)
            
            return
        }

        guard let mainCoin = balanceResponse.mainCoin else {
            handleErrorCase()

            return
        }

        var coins = assetsResponse?.all.map { $0.coin } ?? balanceResponse.crypto?.map { $0.coin } ?? []
        
        if let requestedCoin = stateInfo.requestInfo?.currency,
           requestedCoin != "EUR",
           !coins.contains(requestedCoin) {
            coins.append(requestedCoin)
        }

        let assetsPricesFetcher = provideAssetsPriceFetcher(for: coins, mainCoin: mainCoin)

        assetsPricesFetcher            .receive(on: RunLoop.main)
            .sink { [ weak self ] completion in
                self?.isLoading.send(false)
                if case let .failure(error) = completion, let fetchError = error as? DataFetchingError,
                   case .binanceError = fetchError {
                    self?.handleAccountInfoFetching(balanceResponse: balanceResponse, assetsResponse: assetsResponse, doesHaveCryptoInfo: false)
                } else {
                    self?.handleSubscriptionCompletion(completion)
                }
            } receiveValue: { [ weak self ]  pricesResponse in
                var neededCoins = balanceResponse.crypto?.map { $0.coin } ?? []
                
                if let requestedCoin = self?.stateInfo.requestInfo?.currency,
                   requestedCoin != "EUR" {
                    neededCoins.append(requestedCoin)
                }
                
                self?.handleAssetsPrices(pricesResponse, mainCoin: mainCoin)
                self?.handleAccountInfoFetching(balanceResponse: balanceResponse, assetsResponse: assetsResponse, doesHaveCryptoInfo: true)
            }
            .store(in: &cancellables)
    }

    private func handleSubscriptionCompletion(_ completion: Subscribers.Completion<Error>) {
        if case let .failure(error) = completion {
            handleErrorCase(error)
        }
    }

    private func handleErrorCase(_ error: Error? = nil) {
        isLoading.send(false)
        emptyStateReason = .error
        isEmptyState.send(true)
    }

    private func handleAccountInfoFetching(balanceResponse: AccountsBalanceResponse,
                                           assetsResponse: GetCryptoAssetsResponse?,
                                           doesHaveCryptoInfo: Bool) {
        
        guard stateInfo.isRequesting || balanceResponse.hasEnoughtBalance else {
            // TODO: - maybe we need anouther error messages
            emptyStateReason = .error
            isEmptyState.send(true)
            
            return
        }
        
        let selectedCoin = prepareSelectedCoin(balanceResponse: balanceResponse, assetsResponse: assetsResponse)
        let headerModel = ChannelPaymentHeaderViewModel(accountsBalanceInfo: balanceResponse,
                                                        requestInfo: stateInfo.requestInfo,
                                                        doesHaveCryptoInfo: doesHaveCryptoInfo,
                                                        selectedCoin: selectedCoin,
                                                        membersInfoSetupModel: membersInfoHolderViewModel,
                                                        assetsPrices: assetsPrices,
                                                        mainCoinPriceInEuro: mainCoinPriceInEuro,
                                                        title: Constants.Localization.Common.moneyAmount)
        
        let setupModel = ChannelPaymentStackViewModel(channelInfo: stateInfo.channelInfo,
                                                      amounts: prepareAmountsRanges(for: balanceResponse),
                                                      headerModel: headerModel,
                                                      footerModel: footerSetupModel,
                                                      downloadManager: inputs.downloadManager)
        
        self.setupModel.send(setupModel)
        self.bindToSeeAllUsers(setupModel: setupModel)
        self.setupHeaderModel()
        self.allAssetsResponse = assetsResponse
        self.prepareAmount()
        self.prepareCoinsPicker()
    }
    
    private func prepareAmount() {
        if stateInfo.isRequesting {
            updateConvertedValue()
        } else {
            guard let amount = self.prepareAmountForAccepting(),
                  let headerModel = setupModel.value?.headerModel else { return }
            
            let amountText = headerModel.isCashSelected ? amount.bringToPresentableFormat(usesGroupingSeparator: false)
                                                        : amount.formattedDecimalNumber(usesGroupingSeparator: false)
            setupModel.value?.headerModel.amountViewSetupModel.amount.send(amountText)
        }
    }
    
    private func bindToSeeAllUsers(setupModel: ChannelPaymentStackViewModel) {
        setupModel.headerModel.membersInfoSetupModel.moreButtonTapHandler
            .sink { [ weak self ] in
                self?.channelParticipantsPresenterPublisher.send(())
            }
            .store(in: &cancellables)
        
        setupModel.headerModel.membersInfoSetupModel.addMoreParticipantsButtonTapHandler
            .sink { [ weak self ] in
                self?.addNewParticipantsPublisher.send(())
            }
            .store(in: &cancellables)
    }

    private func setupHeaderModel() {
        setupModel.value?.headerModel.amountViewSetupModel.cryptoPickerChangePusblisher
            .sink(receiveValue: { [ weak self ] in
                self?.cryptoPickerPublisher.send(())
            })
            .store(in: &cancellables)
        
        setupModel.value?.headerModel.amountViewSetupModel.amountTypePickerPublisher
            .sink(receiveValue: { [ weak self ] in
                self?.amountTypePickerPublishers.send(())
            })
            .store(in: &cancellables)

        setupModel.value?.headerModel.cryptoAccountUpdatePublisher
            .sink { [ weak self ] reason in
                self?.cryptoAccountUpdatePublisher.send(reason)
            }
            .store(in: &cancellables)

        bindToPaymentAmount()
        bindToSelectedCoinChange()
        bindToAppStateNotification()
        bindToFooterActionsPublisher()
        bindToPaymentMethodTypeChange()
    }
    
    func updateAmountType(_ amountType: AmountType) {
        setupModel.value?.headerModel.amountViewSetupModel.amountType.send(amountType)
    }
        
    func prepareCoinsPicker() {
        guard let allAssetsResponse, stateInfo.isRequesting else {
            let userCryptos = setupModel.value?.headerModel.accountsBalanceInfo.crypto ?? []
            CryptoCacher.global.cachedData = userCryptos.map { .init(name: $0.name,
                                           abbriviation: $0.coin,
                                           iconPath: Constants.AppURL.cryptoIconURL(coin: $0.coin)?.absoluteString,
                                           balance: $0.balance) }
            
            return
        }
        
        CryptoCacher.global.cachedData = allAssetsResponse.all.map { .init(name: $0.name,
                                                 abbriviation: $0.coin,
                                                 iconPath: $0.iconPath,
                                                 balance: $0.balance) }
    }

    // MARK: - Binding
    
    private func bindToPaymentMethodTypeChange() {
        setupModel.value?.headerModel.paymentMethodTypeSegmentedControlViewModel?.selectedIndex
            .sink { [ weak self ] _ in
                self?.updateAvailableAmount()
                self?.prepareAmount()
            }
            .store(in: &cancellables)
    }
    
    private func bindToSelectedCoinChange() {
        setupModel.value?.headerModel.selectedCoinPublisher
            .sink { [ weak self ] coin in
                self?.updateAvailableAmount()
                self?.prepareAmount()

                if let coin {
                    self?.subcribeToCoin(coin.abbriviation)
                }
             }
            .store(in: &cancellables)
    }

    private func bindToFooterActionsPublisher() {        
        setupModel.value?.footerModel.transactionButtonHandler
            .sink { [ weak self ] isRequesting in
                self?.transactionButtonHandler.send(isRequesting)
            }
            .store(in: &cancellables)
    }

    var paymentAmount: Double? {
        guard let headerModel = self.setupModel.value?.headerModel,
              let amount = headerModel.amountViewSetupModel.amount.value,
              let doubledAmount = Double(amount.replacingOccurrences(of: ",", with: "")) else { return nil }
        return doubledAmount
    }

    func performTransaction(peers: [SwordPeer], isRequesting: Bool, checkedAmount: Double? = nil) {
        guard let headerModel = self.setupModel.value?.headerModel else { return  }
        
        var paymentAmount: Double?
        
        if let checkedAmount {
            paymentAmount = checkedAmount
        } else {
            if let amount = headerModel.amountViewSetupModel.amount.value,
               let doubledAmount = amount.formattedDecimalNumber(maximumFractionDigits: headerModel.amountViewSetupModel.precistionCount) {
                paymentAmount = doubledAmount
            } else {
                if stateInfo.requestInfo == nil {
                    return
                }
            }
        }

        guard let route = prepareRouteForTransaction(peers: peers,
                                                     amount: paymentAmount,
                                                     isRequesting: isRequesting) else { return }
        
        isLoading.send(true)
        
        inputs.makePaymentService.fetch(route: route)
            .receive(on: RunLoop.main)
            .sink { [ weak self ] completion in
                self?.isLoading.send(false)
                if case let .failure(error) = completion {
                    self?.error.send(error)
                }
            } receiveValue: { [ weak self ] response in
                CryptoCacher.global.prepareCryptosInfo()
                if let redirectURL = response.data.redirectUrl {
                    self?.storeState(with: .payment)
                    self?.redirectingSource = .payment
                    self?.redirectURLPublisher.send(redirectURL)
                } else {
                    self?.paymentCompletion.send(())
                }
            }
            .store(in: &cancellables)
    }
    
    private func prepareRouteForTransaction(peers: [SwordPeer], amount: Double?, isRequesting: Bool) -> MakePaymentRouting? {
        guard let headerModel = self.setupModel.value?.headerModel else { return nil }
        
        let paymentMethodTypeInfo = headerModel.paymentMethodTypeInfo.value
        let paymentType: PaymentType = isRequesting ? .request : .pay
        let amountType = headerModel.amountViewSetupModel.amountType.value

        if stateInfo.isRequesting {
            return MakePaymentParams(currencyType: paymentMethodTypeInfo.abbreviation,
                                     paymentType: paymentType,
                                     paymentMethodType: headerModel.paymentMethodsType,
                                     amountType: amountType,
                                     peers: peers,
                                     note: setupModel.value?.footerModel.note.value)
        } else {
            guard let paymentId = stateInfo.paymentId,
                  let messageId = stateInfo.messageId,
                  let peer = peers.first else { return nil }
            
            return AcceptPaymentParams(paymentId: paymentId,
                                       amount: amount,
                                       currencyType: paymentMethodTypeInfo.abbreviation,
                                       paymentMethodType: headerModel.paymentMethodsType,
                                       note: setupModel.value?.footerModel.note.value,
                                       messageId: messageId,
                                       peer: peer)
        }
    }

    private func convertAmountIfNeeded(amount: Double) -> Double {
        guard let headerModel = setupModel.value?.headerModel,
              headerModel.paymentMethodTypeInfo.value.abbreviation != "EUR" && headerModel.amountViewSetupModel.amountType.value == .fiat
            else { return amount }
        
        return convertAmountToCrypto(amount: amount,
                                     fromCurrency: "EUR",
                                     to: headerModel.paymentMethodTypeInfo.value.abbreviation) ?? amount
    }

    private func isAmountInCorrectRange(amount: Double, currency: String) -> Bool {
        return isEuroAmountInCorrectRange(amount: amount, isForCrypto: false)
    }
    
    private func isEuroAmountInCorrectRange(amount: Double, isForCrypto: Bool) -> Bool {
        let minValue: Double = 1
        
        return amount >= minValue
    }

    private func hasUserEnoughtBalance(for amount: Double, currency: String?) -> Bool {
        guard let currency,
              let userBalance = setupModel.value?.headerModel.accountsBalanceInfo else { return false }
        
        var balanceAmount: Double?
        
        if currency == "EUR" {
            balanceAmount = 0
        } else {
            balanceAmount = userBalance.crypto?.first(where: { $0.coin == currency })?.balance
        }

        guard let balanceAmount else { return false }
        
        return balanceAmount >= amount
    }

    private func bindToPaymentAmount() {
        setupModel.value?.headerModel.amountViewSetupModel.amount
            .sink(receiveValue: { _ in
//                self?.validateAmount(paymentAmount)
            })
            .store(in: &cancellables)
    }
    
    private func bindToActionButtonState() {
//        amountValidator
//            .sink(receiveValue: { [ weak self ] isAmountValid in
//                self?.setupModel.value?.footerModel.payButtonViewModel.isActive.send(isAmountValid)
//                self?.setupModel.value?.footerModel.requestButtonViewModel.isActive.send(isAmountValid)
//            })
//            .store(in: &cancellables)
    }
    
    private func storeState(with redirectingSource: RedirectingSource) {
        AppData.payOrRequestStateInfo = stateInfo
        AppData.payOrRequestStateInfo?.redirectingSource = redirectingSource
    }
    
    private func prepareAmountsRanges(for balanceResponse: AccountsBalanceResponse) -> ChannelPaymentStackViewModel.Amount {
        if stateInfo.isRequesting {
            return .init(available: nil, min: "1 EUR", max: "1000000 EUR")
        } else {
            return .init(min: "1 EUR", max: "1000000 EUR")
        }
    }
    
    private func prepareSelectedCoin(balanceResponse: AccountsBalanceResponse,
                                     assetsResponse: GetCryptoAssetsResponse?) -> CryptoPickerItemCellModel.CoinInfo? {
        if let userCoin = balanceResponse.crypto?.first {
            return .init(name: userCoin.coin,
                         abbriviation: userCoin.coin,
                         iconPath: Constants.AppURL.cryptoIconURL(coin: userCoin.coin)?.absoluteString,
                         balance: userCoin.balance)
        }
        
        if let availableCoin = assetsResponse?.all.first {
            return .init(name: availableCoin.name,
                         abbriviation: availableCoin.coin,
                         iconPath: availableCoin.iconPath,
                         balance: availableCoin.balance)
        }
        
        return nil
    }
    
    private func updateAvailableAmount() {
        guard let headerModel = setupModel.value?.headerModel else { return }

        let amounts: ChannelPaymentStackViewModel.Amount

        lazy var availableCashAmountText: String? = {
            return nil
        }()

        let availableCryptoText: String? = {
            guard let selectedCrypto = headerModel.selectedCoinPublisher.value?.abbriviation,
                  let selectedCryptoBalnce = headerModel.accountsBalanceInfo.crypto?.first(where: {$0.coin == selectedCrypto})?.balance else { return nil }
            
            return "\(selectedCryptoBalnce.bringToPresentableFormat()) \(selectedCrypto)"
        }()
        
        let segmentedControlSelectedValue = headerModel.paymentMethodTypeSegmentedControlViewModel?.selectedIndex.value
        let isCashSelected = (segmentedControlSelectedValue != nil && segmentedControlSelectedValue == 0) || (segmentedControlSelectedValue == nil && headerModel.isCashAvailable)

        if stateInfo.isRequesting {
            let minValue = isCashSelected ? "1 EUR" : "1.00 EUR"

            amounts = .init(available: isCashSelected ? availableCashAmountText : availableCryptoText,
                            min: minValue,
                            max: "1000000 EUR")
        } else {
            if isCashSelected {
                amounts = .init(available: availableCashAmountText,
                                min: "1 EUR",
                                max: "1000000 EUR")
            } else {
                amounts = .init(min: "1 EUR",
                                max: "1000000 EUR")
            }
        }

        setupModel.value?.amounts.send(amounts)
    }
}

// MARK: - Amount Validation
extension ChannelPaymentViewModel {
    private func provideAssetsPriceFetcher(for coins: [String], mainCoin: String) -> AnyPublisher<Array<AssetsPricesChangesResponse>, Error> {
        var priceChangeCoins: [ String ] = coins.compactMap {
            guard $0 != mainCoin else { return nil }
   
            return "\"\($0)\(mainCoin)\""
        }

        priceChangeCoins.append("\"EUR\(mainCoin)\"")
        let priceChangesSymbols: String = priceChangeCoins.joined(separator: ",")
        let assetsPricesChangesRoute = AssetsPricesChangesParams(symbols: "[\(priceChangesSymbols)]")

        return inputs.assetsPricesChangesService.fetch(route: assetsPricesChangesRoute)
    }
    
    private func subscribeToMainCryptoPriceChange(mainCoin: String) {
        let dict: [String: Any] = [
                                    "method": "SUBSCRIBE",
                                    "params": [ "eur\(mainCoin.lowercased())@aggTrade" ],
                                    "id": 10
                                  ]

        WebSocketManager.global.sendData(dict)
        
        if let requestedCoin = stateInfo.requestInfo?.currency, requestedCoin != "EUR" {
            subscribeToCryptoPriceChange(force: true, coin: requestedCoin)
        }
    }
    
    private func subcribeToCoin(_ coin: String) {
        if let previousSelectedCoin {
            subscribeToCryptoPriceChange(force: false, coin: previousSelectedCoin)
        }
        
        subscribeToCryptoPriceChange(force: true, coin: coin)
        
        previousSelectedCoin = coin
    }

    private func subscribeToCryptoPriceChange(force toSubscribe: Bool, coin: String) {
        guard let mainCoin = setupModel.value?.headerModel.accountsBalanceInfo.mainCoin else { return }

        let params = ["\(coin.lowercased())\(mainCoin.lowercased())@ticker"]

        let method = toSubscribe ? "SUBSCRIBE" : "UNSUBSCRIBE"
        let dict: [String: Any] = [
                                    "method": method,
                                    "params": params,
                                    "id": 50
                                  ]

        WebSocketManager.global.sendData(dict)
    }

    private func setupSubscribers() {
        WebSocketManager.global.connect()
        WebSocketManager.global.addSubscriber(tradeDataPublisher, for: .trade)
        WebSocketManager.global.addSubscriber(tickerDataPublisher, for: .miniTicker)
    }

    private func bindToSocketConnection() {
        WebSocketManager.global.isConnected
            .sink { [ weak self ] isConnected in
                if isConnected {
                    if let mainCoin = self?.mainCoin {
                        self?.subscribeToMainCryptoPriceChange(mainCoin: mainCoin)
                    }
                    
                    if let selectedCoin = self?.setupModel.value?.headerModel.selectedCoinPublisher.value {
                        self?.subcribeToCoin(selectedCoin.abbriviation)
                    }
                }
            }
            .store(in: &cancellables)
    }

    private func bindToCryptoPricesChanges() {
        tradeDataPublisher.sink { [ weak self ] data in
            guard let self,
                  let mainCoin = self.mainCoin,
                  let model = data as? TradeSocketResponse,
                  model.symbols == "EUR\(mainCoin)",
                  let price = Double(model.price) else { return }
            self.mainCoinPriceInEuro = 1 / price
        }
        .store(in: &cancellables)
        
        tickerDataPublisher.sink { [ weak self ] data in
            guard let self,
                  let model = data as? MiniTickerSocketResponse,
                  let index = self.assetsPrices.firstIndex(where: { $0.symbol == model.symbol }) else { return }

            self.assetsPrices[Int(index)].price = model.closePrice
        }
        .store(in: &cancellables)
    }
    
    private func bindToAppStateNotification() {
        NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)
            .sink { _ in
                WebSocketManager.global.connect()
            }
            .store(in: &cancellables)

        NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)
            .sink { _ in
                WebSocketManager.global.disconect()
            }
            .store(in: &cancellables)
            
        InternetManagerProvider.reachability.internetRechabilityPublisher
            .sink { status in
                if let status, case .reachable = status {
                    WebSocketManager.global.connect()
                } else {
                    WebSocketManager.global.disconect()
                }
            }
            .store(in: &cancellables)
    }

    private func handleAssetsPrices(_ prices: [AssetsPricesChangesResponse], mainCoin: String) {
        self.assetsPrices = prices.map { AssetsPricesOnMainCoinResponse(symbol: $0.symbol, price: $0.usablePrice) }
        assetsPrices.append(.init(symbol: "\(mainCoin)\(mainCoin)", price: "1"))
        
        if let priceValue = self.assetsPrices.first(where: { $0.symbol == "EUR\(mainCoin)" })?.price,
           let price = Double(priceValue) {
            self.mainCoinPriceInEuro = 1 / price
        }
        
        self.setupSubscribers()
        self.subscribeToMainCryptoPriceChange(mainCoin: mainCoin)
    }
        
    private func convertAmountToEuro(_ amount: Double, coin: String?) -> Double? {
        guard let coin,
              mainCoin != nil,
              let selectedCoinPriceToMainCoinPrice = assetsPrices.first(where: { $0.symbol == "\(coin)\(mainCoin!)" })?.price,
              let doubledPrice = Double(selectedCoinPriceToMainCoinPrice),
              let mainCoinPriceInEuro else {
            return nil
        }
        
        return doubledPrice * mainCoinPriceInEuro * amount
    }
    
    private func prepareAmountForAccepting() -> Double? {
        guard let headerModel = setupModel.value?.headerModel,
              let requestedAmount = stateInfo.requestInfo?.amount,
              let doubledAmount = Double(requestedAmount),
              let fromCurrency = stateInfo.requestInfo?.currency,
              let toCurrency = (headerModel.isCashSelected ? "EUR" : headerModel.selectedCoinPublisher.value?.abbriviation) else { return nil }

        
        return convert(amount: doubledAmount, fromCurrency: fromCurrency, toCurrency: toCurrency)
    }
    
    private func convert(amount: Double, fromCurrency: String, toCurrency: String) -> Double? {
        if fromCurrency == "EUR" {
            if toCurrency == "EUR" {
                return amount
            } else {
                return convertAmountToCrypto(amount: amount, fromCurrency: "EUR", to: toCurrency)
            }
        } else {
            if toCurrency == "EUR" {
                return convertAmountToEuro(amount, coin: fromCurrency)
            } else {
                if fromCurrency == toCurrency {
                    return amount
                } else {
                    return convertAmountToCrypto(amount: amount, fromCurrency: fromCurrency, to: toCurrency)
                }
            }
        }
    }
    
    private func convertAmountToCrypto(amount: Double, fromCurrency: String, to coin: String) -> Double? {
        guard let mainCoin,
              let euroPriceToBaseCoin = assetsPrices.first(where: { $0.symbol == "\(fromCurrency)\(mainCoin)" }),
              let doubledEuroPrice = Double(euroPriceToBaseCoin.price),
              let coinPriceToBaseCoin = assetsPrices.first(where: { $0.symbol == "\(coin)\(mainCoin)" }),
              let doubledCoinPrice = Double(coinPriceToBaseCoin.price), doubledCoinPrice > 0 else { return nil }
        
        return amount * doubledEuroPrice / doubledCoinPrice
    }
    
    private func updateConvertedValue() {
//        guard let headerModel = setupModel.value?.headerModel else { return }
//
//        guard !headerModel.isCashSelected,
//           let selectedCoin = headerModel.selectedCoinPublisher.value?.abbriviation,
//              let amount = headerModel.amount.value?.replacingOccurrences(of: ",", with: "."),
//              let doubledAmount = Double(amount),
//              let convertedToEuroAmount = convertAmountToEuro(doubledAmount, coin: selectedCoin) else {
//            headerModel.convertedAmountPublisher.send(nil)
//
//            return
//        }
//
//        headerModel.convertedAmountPublisher.send("EUR: \(convertedToEuroAmount.bringToPresentableFormat())")
    }
}
