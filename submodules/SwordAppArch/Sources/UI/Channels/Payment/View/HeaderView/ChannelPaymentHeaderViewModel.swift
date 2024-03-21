//
//  ChannelPaymentHeaderViewModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 27.12.22.
//

import Combine
import Foundation

public final class ChannelPaymentHeaderViewModel {
    private var cancellables: Set<AnyCancellable> = []
    private let downloadManager: DataDownloadManaging = DataDownloadManagerProvider.default

    lazy var amountViewSetupModel: ChannelPaymnetAmountViewModel = {
        var selectedCrypto: ChannelPaymnetAmountViewModel.CryptoInfo? = nil

        if let price = priceForSelectedCoin(),
           let selectedCoin = selectedCoinPublisher.value,
           !isCashSelected {
            selectedCrypto = ChannelPaymnetAmountViewModel.CryptoInfo(selectedCoin: selectedCoin,
                                                                      price: price)
        }

        return .init(selectedCoin: selectedCrypto,
                     isPaying: isPaying,
                     canChangePaymentMethods: canChangePaymentMethods,
                     canEditAmount: canEditAmount,
                     title: title)
    }()

    var isCashAvailable: Bool {
        return true // (!isPaying && (AppData.currentUserInfo?.hasFiatAccount ?? false)) || ((accountsBalanceInfo.fiat?.balance ?? 0) > 0)
    }
    
    var isCryptoAvailable: Bool {
        return !isPaying || accountsBalanceInfo.hasEnoughtCrypto
    }
    
    var isCashSelected: Bool {
        guard let paymentMethodTypeSegmentedControlViewModel else { return isCashAvailable }

        return isCashAvailable && paymentMethodTypeSegmentedControlViewModel.selectedIndex.value == 0
    }

    let membersInfoSetupModel: ChannelPaymentParticipantsViewModel
    let requestInfo: DecodableMessage?
    let doesHaveCryptoInfo: Bool
    var accountsBalanceInfo: AccountsBalanceResponse

    let paymentMethodTypeHandler: PassthroughSubject<Void, Never> = PassthroughSubject()
    let cryptoIconDataPublisher: PassthroughSubject<Data?, Never> = PassthroughSubject()
    
    var paymentMethodsType = PaymentMethodType.fiat
    var selectedCoinPublisher: CurrentValueSubject<CryptoPickerItemCellModel.CoinInfo?, Never>
    var paymentMethodTypeInfo: CurrentValueSubject<PaymentMethodTypeModel, Never>
    var amountPlaceholder: CurrentValueSubject<NSAttributedString, Never> = CurrentValueSubject(NSAttributedString(string: ""))
    let amountValidationErrorPublisher: PassthroughSubject<String?, Never> = PassthroughSubject()
    let canEditAmount: Bool
    let title: String
    
    var isPaying: Bool {
        return requestInfo != nil
    }

    var canChangePaymentMethods: Bool {
        return isCryptoAvailable && paymentMethodTypeSegmentedControlViewModel?.selectedIndex.value == 1
    }

    let cryptoAccountUpdatePublisher: PassthroughSubject<UnavailableCryptoReason, Never> = .init()
    lazy var paymentMethodTypeSegmentedControlViewModel: SegmentedControlSetupModel? = {
        guard let user = AppData.currentUserInfo else { return nil }
        
        var models: [SegmentedControlSetupModel.ItemModel] = []
        
        if isCashAvailable  {
            models.append(.init(title: Constants.Localization.Common.cash,
                                isSelected: CurrentValueSubject(true)))
        }
        
        if isCryptoAvailable {
            models.append(.init(title: Constants.Localization.Common.crypto,
                                isSelected: CurrentValueSubject(false)))
        }
        
        guard models.count == 2 else { return nil }
        
        return .init(models: models)
    }()

    var assetsPrices: [AssetsPricesOnMainCoinResponse] = [] {
        didSet {
            updateSelectedCoinPrice()
        }
    }
    var mainCoinPriceInEuro: Double? {
        didSet {
            updateSelectedCoinPrice()
        }
    }

    func priceForSelectedCoin() -> Double? {
        guard let selectedCoin = selectedCoinPublisher.value,
              let selectedCoinPriceToMainCoinPrice = assetsPrices.first(where: { $0.symbol.hasPrefix(selectedCoin.abbriviation) })?.price,
              let doubledPrice = Double(selectedCoinPriceToMainCoinPrice),
              let mainCoinPriceInEuro  else { return nil }
        
        return doubledPrice * mainCoinPriceInEuro
    }

    private func updateSelectedCoinPrice() {
        guard let selectedCoin = amountViewSetupModel.selectedCrypto.value,
              let newPrice = priceForSelectedCoin() else { return }
        
        let newCoin = ChannelPaymnetAmountViewModel.CryptoInfo(selectedCoin: selectedCoin.selectedCoin,
                                                               price: newPrice)
        
        amountViewSetupModel.selectedCrypto.send(newCoin)
    }

    init(accountsBalanceInfo: AccountsBalanceResponse,
         requestInfo: DecodableMessage?,
         doesHaveCryptoInfo: Bool,
         selectedCoin: CryptoPickerItemCellModel.CoinInfo?,
         membersInfoSetupModel: ChannelPaymentParticipantsViewModel,
         assetsPrices: [AssetsPricesOnMainCoinResponse],
         mainCoinPriceInEuro: Double?,
         canEditAmount: Bool = false,
         title: String) {
        let paymentMethodInfo: PaymentMethodTypeModel =  .init(name: "EUR", abbreviation: "EUR")

        self.selectedCoinPublisher = .init(selectedCoin)
        self.requestInfo = requestInfo
        self.doesHaveCryptoInfo = doesHaveCryptoInfo
        self.accountsBalanceInfo = accountsBalanceInfo
        self.paymentMethodTypeInfo = .init(paymentMethodInfo)
        self.membersInfoSetupModel = membersInfoSetupModel
        self.assetsPrices = assetsPrices
        self.mainCoinPriceInEuro = mainCoinPriceInEuro
        self.canEditAmount = canEditAmount
        self.title = title

        self.prepareAmountPlaceholder(isCashSelected: true)

        bindToPaymentMethodTypeChange()
        
        paymentMethodsType = .fiat
    }

    private func bindToPaymentMethodTypeChange() {
        paymentMethodTypeSegmentedControlViewModel?
            .selectedIndex
            .sink { [ weak self ] index in
                guard let self else { return }

                let isCashSelected = index == 0
                
                if isCashSelected {
                    amountViewSetupModel.amountType.send(.fiat)
                }

                let isCryptoAvailable = AppData.currentUserInfo?.status == .active && doesHaveCryptoInfo
                
                if !isCashSelected && !isCryptoAvailable {
                    DispatchQueue.main.async {
                        self.paymentMethodTypeSegmentedControlViewModel?.updateSelectedIndex(to: 0)
                    }
                    let reason = prepareUnavailableCryptoReason()
                    cryptoAccountUpdatePublisher.send(reason)

                    return
                }

                let paymentMethodType = self.providePaymentMethodInfo(isCashSelected: isCashSelected)
                var selectedCrypto: ChannelPaymnetAmountViewModel.CryptoInfo? = nil
                
                if let price = self.priceForSelectedCoin(),
                   let selectedCoin = self.selectedCoinPublisher.value,
                   !isCashSelected {
                    selectedCrypto = ChannelPaymnetAmountViewModel.CryptoInfo(selectedCoin: selectedCoin,
                                                                              price: price)
                }

                self.paymentMethodsType = isCashSelected ? .fiat : .crypto
                self.prepareAmountPlaceholder(isCashSelected: isCashSelected)
                self.paymentMethodTypeInfo.send(paymentMethodType)
                self.amountViewSetupModel.selectedCrypto.send(selectedCrypto)

                if self.isPaying {
                    let amountType: AmountType = isCashSelected ? .fiat : .crypto
                    self.amountViewSetupModel.amountType.send(amountType)
                }
            }
            .store(in: &cancellables)
    }
    
    private func providePaymentMethodInfo(isCashSelected: Bool) -> PaymentMethodTypeModel {
        return isCashSelected ? .init(name: "EUR", abbreviation: "EUR")
                              : .init(name: selectedCoinPublisher.value?.name ?? "EUR",
                                       abbreviation: selectedCoinPublisher.value?.abbriviation ?? "EUR",
                                       icon: selectedCoinPublisher.value?.iconPath)
    }

    private func prepareAmountPlaceholder(isCashSelected: Bool) {
        let text = isCashSelected ? Constants.Localization.Channels.cashPlaceholder
                                  : Constants.Localization.Channels.cryptoPlaceholder

        let attributedPlaceholder = NSAttributedString(string: text,
                                                       attributes: [.font: ThemeProvider.currentTheme.fonts.rubikItalic(ofSize: 17),
                                                                    .foregroundColor: ThemeProvider.currentTheme.colors.textColor.withAlphaComponent(0.6)])
        
        amountPlaceholder.send(attributedPlaceholder)
    }

    func prepareCryptoImageData(for iconPath: String) {
        guard let iconURL = URL(string: iconPath) else {
            cryptoIconDataPublisher.send(nil)
            
            return
        }

        downloadManager.download(from: iconURL)
            .sink { [ weak self ] completion in
                switch completion {
                case .failure(_):
                    self?.cryptoIconDataPublisher.send(nil)
                default:
                    return
                }
            } receiveValue: { [ weak self ] data in
                self?.cryptoIconDataPublisher.send(data)
            }
            .store(in: &cancellables)
    }
        
    func cancelCurrentPaymentMethodIconDownloading() {
        guard let iconPath = paymentMethodTypeInfo.value.icon,
              let iconURL = URL(string: iconPath) else {
            return
        }

        downloadManager.cancelDownloading(for: iconURL)
    }
    
    private func prepareUnavailableCryptoReason() -> UnavailableCryptoReason {
        return .error
    }
}

enum UnavailableCryptoReason {
    case error
}
