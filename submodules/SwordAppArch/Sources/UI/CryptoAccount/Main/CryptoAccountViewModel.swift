//
//  CryptoAccountViewModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 20.12.22.
//

import Combine
import Foundation

public struct CryptoAccountViewModelInputs {
    let downloadManager: DataDownloadManaging
    let getCryptoBalanceService: GetCryptoBalanceServicing
    let getCryptoAssetsService: GetCryptoAssetsServicing
    let assetsPricesChangesService: AssetsPricesChangesServicing
    let getAssetItemInfoService: GetAssetItemInfoServicing
}

public final class CryptoAccountViewModel: BaseViewModel<CryptoAccountViewModelInputs>, DataSourced {
    public var dataSource: CurrentValueSubject<[CryptoAccountSection], Never> = .init([])
    public var addedRowsInfo: TableViewUpdatingDataModel = .init(status: .insert)
    public var deletedRowsInfo: TableViewUpdatingDataModel = .init(status: .deleted)
    
    /// Timer

    let emptyStateModel: TextedEmptyStateViewModel = .init(title: Constants.Localization.Common.errorMessage,
                                                           actionTitle: Constants.Localization.Common.refresh)
    let headerViewModel: CurrentValueSubject<CryptoAccountHeaderViewModel?, Never> = CurrentValueSubject(nil)
    let searchBarSetupModel = SearchBarHeaderViewModel(placeholder: Constants.Localization.CryptoAccount.searchPlaceholder)

    var cryptoAccountInfoDidChange = false
    
    var cryptoAssetsResponse: GetCryptoAssetsResponse?
    var filteredCryptoAssetsResponse: GetCryptoAssetsResponse?
    
    // Crypto
    private var assetsPrices: [AssetsPricesOnMainCoinResponse] = []
    private var assetsPricesChagnes: [AssetsPricesChangesResponse] = []
    
    var mainCoinPriceInEuro: Double?
    var mainCoin: String?
    private var userBalance: Double = 0
    
    var tradeDataPublisher: PassthroughSubject<Any, Never> = .init()
    var tickerDataPublisher: PassthroughSubject<Any, Never> = .init()
    
    var visibleIndexPaths: [IndexPath] = []
    private var dataExpirationTimer: Timer?
    
    var isLoadingAfterRedirection: Bool = false
    
    public override init(inputs: CryptoAccountViewModelInputs) {
        super.init(inputs: inputs)
        
        bindToSearchTerm()
        bindToSearchingState()
        bindToSearchCancelling()
        bindToEmptyStateModelAction()
        bindToCryptoAccountInfoChangingNotification()
    }
    
    func updateVisibleItems(at indexPaths: [IndexPath], newMainPrice: Double) {
        mainCoinPriceInEuro = newMainPrice
        if let headerViewModel = headerViewModel.value {
            headerViewModel.cryptoAccountModel.balanceInEuro.send(headerViewModel.cryptoAccountModel.balance.value * newMainPrice)
        }
        
        indexPaths.forEach {
            if let cellModel = self.cellModel(for: $0),
               let price = self.price(of: cellModel.cryptoModel.abbreviation) {
                updateCryptoPrice(cellModel, price, newMainPrice)
            }
        }
    }
    
    func updateVisibleCellPriceChangesIfNeeded(model: MiniTickerSocketResponse, visibleCellsIndexPaths: [IndexPath]) {
        visibleCellsIndexPaths
            .compactMap { cellModel(for: $0) }
            .filter {
                guard let mainCoin else { return false }
                
                return "\($0.cryptoModel.abbreviation)\(mainCoin)" == model.symbol
            }
            .forEach { cellModel in
                cellModel.cryptoModel.oscillation.send(model.priceChange)
                cellModel.cryptoModel.oscillationByPercent.send(model.priceChangePercent)
                if let price = Double(model.closePrice),
                   let mainCoinPriceInEuro {
                    updateCryptoPrice(cellModel, price, mainCoinPriceInEuro)
                    
                    if let index = assetsPrices.firstIndex(where: { $0.symbol == model.symbol }) {
                        assetsPrices[Int(index)].price = model.closePrice
                    }
                }
            }
    }
    
    func reconnectStreams(visibleCellsIndexPaths: [IndexPath]) {
        subscribeToMainCryptoPriceChange()
        subscribeToCryptoPricesChanges(force: true, at: visibleCellsIndexPaths)
    }
    
    func provideDataSource() {
        let response = filteredCryptoAssetsResponse ?? cryptoAssetsResponse

        guard let response,
              let mainCoinPriceInEuro else {
            dataSource.send([])
            
            return
        }
        
        var dataSource: [CryptoAccountSection] = []
        
        if !response.userCryptos.isEmpty {
            dataSource.append(provideSection(with: "",
                                             and: response.userCryptos,
                                             mainCoinPriceInEuro: mainCoinPriceInEuro))
        }
        
        if !response.topCryptos.isEmpty {
            dataSource.append(provideSection(with: Constants.Localization.CryptoAccount.topCryptos,
                                             and: response.topCryptos,
                                             mainCoinPriceInEuro: mainCoinPriceInEuro))
        }
        
        if !response.availableCryptos.isEmpty {
            dataSource.append(provideSection(with: Constants.Localization.CryptoAccount.exploreMoreCrypto,
                                             and: response.availableCryptos,
                                             mainCoinPriceInEuro: mainCoinPriceInEuro))
        }
        
        var indexPaths: [IndexPath] = []
        
        for (sectionIndex, section) in dataSource.enumerated() {
            if indexPaths.count >= 10 { break }
            
            for cellModelIndex in 0..<(section.cellModels.count) {
                indexPaths.append(IndexPath(row: cellModelIndex, section: sectionIndex))
            }
        }
        
        subscribeToCryptoPricesChanges(force: true, at: indexPaths)
        
        self.dataSource.send(dataSource)
    }
    
    private func provideSection(with title: String, and data: [GetCryptoAssetsResponse.CryptoMainInfo], mainCoinPriceInEuro: Double) -> CryptoAccountSection {
        let headerModel = TitledTableHeaderAndFooterViewModel(title: title,
                                                              font: ThemeProvider.currentTheme.fonts.regular(ofSize: 14, family: .poppins),
                                                              backgroundColor: ThemeProvider.currentTheme.colors.mainWhite)
        
        let cellModels = data.compactMap {
            guard let priceOnMainCoin = price(of: $0.coin),
                  let priceChange = priceChange(of: $0.coin) else { return nil }
            
            var cryptoAccountModel: CryptoAccountModel?
            
            if let balance = $0.balance {
                cryptoAccountModel = .init(balance: balance,
                                           balanceInEuro: balance * mainCoinPriceInEuro,
                                           totalReturn: balance,
                                           totalReturnByPercent: balance)
            }
            
            return CryptoModel(id: UUID().uuidString,
                               name: $0.name,
                               abbreviation: $0.coin,
                               priceToMainCoin: priceOnMainCoin,
                               priceInEuro: priceOnMainCoin * mainCoinPriceInEuro,
                               iconPath: "\(Constants.AppURL.assetsBaseURL)crypto/\($0.coin).png",
                               oscillation: priceChange.priceChange,
                               oscillationByPercent: priceChange.priceChangePercent,
                               networks: $0.networks,
                               freeze: $0.freeze,
                               locked: $0.locked,
                               accountInfo: cryptoAccountModel) }
            .map {
                CryptoItemCellModel(cryptoModel: $0, downloadManager: inputs.downloadManager)
            }
        
        return CryptoAccountSection(headerModel: headerModel, cellModels: cellModels)
    }
    
    func prepareAccountInfo(withLoading: Bool = true) {
        guard AppData.currentUserInfo?.status == .active else {
            dataSource.send([])
            
            return
        }

        let route = GetCryptoBalanceParams()
        let cryptoAssetsRoute = GetCryptoAssetsParams()
        
        if withLoading {
            isLoading.send(true)
        }
        
        Publishers.CombineLatest(inputs.getCryptoBalanceService.fetch(route: route),
                                 inputs.getCryptoAssetsService.fetch(route: cryptoAssetsRoute))
        .receive(on: RunLoop.main)
        .sink { [ weak self ] completion in
            guard let self else { return }
            
            self.cryptoAccountInfoDidChange = false
            if case .failure(_) = completion {
                self.isLoading.send(false)
                if self.dataSource.value.isEmpty {
                    self.provideDataSource()
                }
            }
        } receiveValue: { [ weak self ] (balanceResponse, assetsResponse) in
            self?.userBalance = balanceResponse.data.balance
            self?.cryptoAssetsResponse = assetsResponse.data
            self?.mainCoin = assetsResponse.data.mainCoin
            self?.fetchAllAssetsPrices()
            CryptoCacher.global.assetsResponse = assetsResponse.data
            CryptoCacher.global.prepareCryptosInfo()
        }
        .store(in: &cancellables)
    }
    
    func getSelectedCrypto(from queryItems: [URLQueryItem]) -> CryptoModel? {
        guard let coinAbbreviationText = queryItems.first(where: { $0.name == "coin" })?.value else { return nil }
        
        return dataSource.value.reduce([], { partialResult, nextItem in
            partialResult + nextItem.cellModels
        }).first(where: { $0.cryptoModel.abbreviation == coinAbbreviationText })?.cryptoModel
    }
    
    // MARK: Binding
    
    private func bindToEmptyStateModelAction() {
        emptyStateModel.actionTapHandler
            .sink { [ weak self ] in
                self?.prepareAccountInfo()
            }
            .store(in: &cancellables)
    }

    private func bindToCryptoAccountInfoChangingNotification() {
        NotificationCenter.default.publisher(for: .cryptoAccountInfoDidChange)
            .sink { [ weak self ] _ in
                self?.cryptoAccountInfoDidChange = true
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Crypto Data live updates
    
    func subscribeToCryptoPricesChanges(force toSubscribe: Bool, at indexPaths: [IndexPath]) {
        guard let mainCoin, !indexPaths.isEmpty else { return }
        
        let cryptos = indexPaths.compactMap { cellModel(for: $0)?.cryptoModel.abbreviation.lowercased() }
        let params = cryptos.map { "\($0.lowercased())\(mainCoin.lowercased())@ticker" }
        
        let method = toSubscribe ? "SUBSCRIBE" : "UNSUBSCRIBE"
        let dict: [String: Any] = [
            "method": method,
            "params": params,
            "id": 50
        ]
        
        WebSocketManager.global.sendData(dict)
    }
    
    private func subscribeToMainCryptoPriceChange() {
        guard let mainCoin else { return }
        let dict: [String: Any] = [
            "method": "SUBSCRIBE",
            "params": [ "eur\(mainCoin.lowercased())@aggTrade" ],
            "id": 10
        ]
        
        WebSocketManager.global.sendData(dict)
    }
    
    private func setupSubscribers() {
        WebSocketManager.global.addSubscriber(tradeDataPublisher, for: .trade)
        WebSocketManager.global.addSubscriber(tickerDataPublisher, for: .miniTicker)
    }
    
    private func fetchAllAssetsPrices() {
        guard let cryptoAssetsResponse,
              let mainCoin else {
            isLoading.send(false)
            
            return
        }

        var priceChangeCoins: [ String ] = cryptoAssetsResponse.all.compactMap {
            guard $0.coin != mainCoin else { return nil }

            return "\"\($0.coin)\(mainCoin)\""
        }

        priceChangeCoins.append("\"EUR\(mainCoin)\"")
        let priceChangesSymbols: String = priceChangeCoins.joined(separator: ",")
        let assetsPricesChangesRoute = AssetsPricesChangesParams(symbols: "[\(priceChangesSymbols)]")
        
        inputs.assetsPricesChangesService.fetch(route: assetsPricesChangesRoute)
            .receive(on: RunLoop.main)
            .sink { [ weak self ] completion in
                guard let self else { return }

                self.isLoading.send(false)
                if case let .failure(error) = completion,
                   let fetchError = error as? DataFetchingError,
                   case .binanceError = fetchError {
                    self.isLoading.send(false)
                    if self.dataSource.value.isEmpty {
                        self.provideDataSource()
                    }                }
            } receiveValue: { [ weak self ] pricesChanges in
                guard let self,
                      let mainCoin = self.mainCoin else { return }
                
                self.assetsPricesChagnes = pricesChanges
                self.assetsPrices = pricesChanges.map { AssetsPricesOnMainCoinResponse(symbol: $0.symbol,
                                                                                       price: $0.usablePrice) }
                self.assetsPrices.append(.init(symbol: "\(mainCoin)\(mainCoin)", price: "1"))
                self.assetsPricesChagnes.append(.init(symbol: "\(mainCoin)\(mainCoin)",
                                                      lastPrice: "1",
                                                      priceChange: "1",
                                                      priceChangePercent: "1",
                                                      prevClosePrice: "1"))
                if let priceValue = self.assetsPrices.first(where: { $0.symbol == "EUR\(mainCoin)" })?.price,
                   let price = Double(priceValue) {
                    let mainCoinPriceInEuro =  1 / price
                    self.mainCoinPriceInEuro = mainCoinPriceInEuro

                    let headerModel = CryptoAccountHeaderViewModel(cryptoAccountModel: .init(balance: self.userBalance,
                                                                                             balanceInEuro: self.userBalance * mainCoinPriceInEuro,
                                                                                             totalReturn: 12.1,
                                                                                             totalReturnByPercent: 6.76),
                                                                   searchBarSetupModel: self.searchBarSetupModel)

                    self.headerViewModel.send(headerModel)
                }

                self.setupSubscribers()
                self.provideDataSource()
                self.subscribeToMainCryptoPriceChange()
            }
            .store(in: &cancellables)
    }
    
    private func price(of coin: String) -> Double? {
        guard let mainCoin,
              let priceText = assetsPrices.first( where: {
                  return $0.symbol == "\(coin)\(mainCoin)"
              })?.price,
              let price = Double(priceText) else {
            return nil
        }
        
        return price
    }
    
    private func priceChange(of coin: String) -> AssetsPricesChangesResponse? {
        guard let mainCoin else { return  nil }
        
        return assetsPricesChagnes.first(where: {
            return $0.symbol == "\(coin)\(mainCoin)"
        })
    }
    
    private func updateCryptoPrice(_ cellModel: CryptoAccountSection.CellModel, _ price: Double, _ mainCoinPriceInEuro: Double) {
        if let balance = cellModel.cryptoModel.accountInfo?.balance.value {
            cellModel.cryptoModel.accountInfo?.balanceInEuro.send(balance * price * mainCoinPriceInEuro)
        }
        
        cellModel.cryptoModel.priceToMainCoin = price
        cellModel.cryptoModel.priceInEuro.send(price * mainCoinPriceInEuro)
    }
            
    func fetchCryptoInfo(_ coin: String) {
        let route = GetAssetItemInfoParams(coin: coin)
        let accountBalanceRoute = GetCryptoBalanceParams()
        
        inputs.getAssetItemInfoService.fetch(route: route)
            .combineLatest(inputs.getCryptoBalanceService.fetch(route: accountBalanceRoute))
            .receive(on: RunLoop.main)
            .sink { [ weak self ] completion in
                self?.cryptoAccountInfoDidChange = false
                
                if case let .failure(error) = completion {
                    self?.error.send(error)
                }
            } receiveValue: { [ weak self ] coinBalanceResponse, accountBalanceResponse in
                guard let self else { return }
                
                self.updateCryptoAccountBalance(accountBalanceResponse.data.balance)
                
                if let balance = coinBalanceResponse.data.balance {
                    self.updateCryptoBalance(coin: coin, balance: balance)
                    CryptoCacher.global.prepareCryptosInfo()
                }
            }
            .store(in: &cancellables)
    }
    
    private func updateCryptoAccountBalance(_ balance: Double) {
        guard let mainCoinPriceInEuro else { return }

        userBalance = balance
        headerViewModel.value?.cryptoAccountModel.balance.send(balance)
        headerViewModel.value?.cryptoAccountModel.balanceInEuro.send(balance * mainCoinPriceInEuro)
    }
    
    private func updateCryptoBalance(coin: String, balance: Double) {
        guard let cryptoAssetsResponse else { return }
        
        NotificationCenter.default.post(name: .accountInfoDidChange, object: nil)
        
        if !cryptoAssetsResponse.userCryptos.isEmpty,
           let userCryptosSection = dataSource.value.first,
           let coinCellModel = userCryptosSection.cellModels.first(where: { $0.cryptoModel.abbreviation == coin }) {
            coinCellModel.cryptoModel.accountInfo?.balance.send(balance)
            coinCellModel.cryptoModel.accountInfo?.balanceInEuro.send(balance * coinCellModel.cryptoModel.priceInEuro.value)
        } else {
            prepareAccountInfo(withLoading: false)
        }
    }
    // MARK: - Binding
    
    private func bindToSearchTerm() {
        searchBarSetupModel.searchTerm
            .dropFirst()
            .sink { [ weak self ] term in
                guard let self else { return }
                
                guard let term,
                      !term.isEmpty else {
                    self.filteredCryptoAssetsResponse = nil
                    self.provideDataSource()

                    return
                }
                
                self.filteredCryptoAssetsResponse = self.prepareFilteredCryptoAssetsResponse(term: term)
                self.provideDataSource()
            }
            .store(in: &cancellables)
    }
    
    private func bindToSearchCancelling() {
        searchBarSetupModel.searchCancelPublisher
            .sink { [ weak self ] in
                guard let self else { return }
                
                self.filteredCryptoAssetsResponse = nil
                self.provideDataSource()
            }
            .store(in: &cancellables)
    }

    private func bindToSearchingState() {
        searchBarSetupModel.isSearchActive
            .sink { [ weak self ] isActive in
                guard let self else { return }

                let isInSearchMode = isActive || self.searchBarSetupModel.hasTerm
                let title = isInSearchMode ? Constants.Localization.CryptoAccount.emptyStateTitle
                                     : Constants.Localization.Common.errorMessage
                let actionTitle = isInSearchMode ? nil : Constants.Localization.Common.refresh

                self.emptyStateModel.title.send(title)
                self.emptyStateModel.actionTitle.send(actionTitle)
            }
            .store(in: &cancellables)
    }

    private func prepareFilteredCryptoAssetsResponse(term: String) -> GetCryptoAssetsResponse? {
        guard let cryptoAssetsResponse else { return nil }
        
        
        return GetCryptoAssetsResponse(userCryptos:  filterCryptos(cryptoAssetsResponse.userCryptos, with: term),
                                       topCryptos: filterCryptos(cryptoAssetsResponse.topCryptos, with: term),
                                       availableCryptos: filterCryptos(cryptoAssetsResponse.availableCryptos, with: term),
                                       mainCoin: cryptoAssetsResponse.mainCoin)
    }
    
    private func filterCryptos(_ cryptos: [GetCryptoAssetsResponse.CryptoMainInfo],
                               with term: String) -> [GetCryptoAssetsResponse.CryptoMainInfo] {
        return cryptos.filter {
            $0.name.lowercased().contains(term.lowercased())
                                    || $0.coin.lowercased().contains(term.lowercased())
        }
    }
    
    // MARK: - Timer
    
    func startTimer() {
        dataExpirationTimer = Timer.scheduledTimer(withTimeInterval: 20, repeats: true, block: { [ weak self ] timer in
            guard let self else { return }

            updateData()
        })
    }

    func stopTimer() {
        dataExpirationTimer?.invalidate()
        dataExpirationTimer = nil
    }

    func updateData() {
        guard AppData.currentUserInfo?.status == .active && cryptoAssetsResponse != nil else {
            return
        }

        let route = GetCryptoBalanceParams()
        let cryptoAssetsRoute = GetCryptoAssetsParams()
        
        Publishers.CombineLatest(inputs.getCryptoBalanceService.fetch(route: route),
                                 inputs.getCryptoAssetsService.fetch(route: cryptoAssetsRoute))
        .receive(on: RunLoop.main)
        .sink { completion in
            if case .failure(_) = completion {
                print("Crypto data updating failed")
            }
        } receiveValue: { [ weak self ] (balanceResponse, assetsResponse) in
            guard let self,
                  !self.searchBarSetupModel.isSearchActive.value && !self.searchBarSetupModel.hasTerm else { return }
            CryptoCacher.global.assetsResponse = assetsResponse.data

            CryptoCacher.global.prepareCryptosInfo()

            let needToReloadData = Set(cryptoAssetsResponse?.userCryptos ?? []) != Set(assetsResponse.data.userCryptos)
            
            guard !needToReloadData else {
                self.prepareAccountInfo(withLoading: false)
                print("cryptoAssetsResponse?.userCryptos ?? [] \(cryptoAssetsResponse?.userCryptos ?? [])")
                print("assetsResponse.data.userCryptos \(assetsResponse.data.userCryptos)")

                return
            }
            
            guard !(cryptoAssetsResponse?.userCryptos ?? []).isEmpty else {
                print("no cryptos to update")
                return
            }
            
            print("Crypto data has been updated")
            self.cryptoAssetsResponse = assetsResponse.data
            
            self.updateCryptoAccountBalance(balanceResponse.data.balance)
            assetsResponse.data.userCryptos.forEach { self.updateCryptoBalance(coin: $0.coin, balance: $0.balance ?? 0) }
        }
        .store(in: &cancellables)
    }
}
