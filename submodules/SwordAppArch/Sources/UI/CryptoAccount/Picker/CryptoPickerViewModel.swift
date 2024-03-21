//
//  CryptoMarketViewModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 09.03.23.
//

import Combine
import Foundation

struct CryptoPickerViewModelInputs {
    let getCryptoAssetsService: GetCryptoAssetsServicing
}

final class CryptoPickerViewModel: BaseViewModel<CryptoPickerViewModelInputs>, DataSourced {
    var dataSource: CurrentValueSubject<[CryptoPickerSection], Never> = CurrentValueSubject([])
    let selectedCrypto: CurrentValueSubject<CryptoPickerItemCellModel.CoinInfo?, Never>
    
    var addedRowsInfo: TableViewUpdatingDataModel = .init(status: .insert)
    var deletedRowsInfo: TableViewUpdatingDataModel = .init(status: .deleted)

    let emptyStateModel: TextedEmptyStateViewModel = .init(title: Constants.Localization.Common.errorMessage)
    let headerViewModel = SearchBarHeaderViewModel(placeholder: Constants.Localization.CryptoAccount.searchPlaceholder)
    
    var coins: [CryptoPickerItemCellModel.CoinInfo]

    private var needToInsertRemainingItems: Bool = false
    
    init(inputs: CryptoPickerViewModelInputs,
         coins: [CryptoPickerItemCellModel.CoinInfo],
         selectedCrypto: CurrentValueSubject<CryptoPickerItemCellModel.CoinInfo?, Never>) {
        self.coins = coins
        self.selectedCrypto = selectedCrypto

        super.init(inputs: inputs)
        
        bindToSearchTerm()
        bindToSearchingState()
        bindToSearchCancelling()

    }
    
    func setupData() {
        guard !coins.isEmpty else {
            if !CryptoCacher.global.cachedData.isEmpty {
                provideDataSource(coins: Array(CryptoCacher.global.cachedData.prefix(50)))
                needToInsertRemainingItems = CryptoCacher.global.cachedData.count > 50
                self.coins = CryptoCacher.global.cachedData
            } else {
                prepareAllCryptos()
            }

            return
        }

        provideDataSource(coins: coins)
    }
    
    func insertRemainingItemsIfNeeded() {
        guard needToInsertRemainingItems else { return }
        
        addedRowsInfo.indexPaths = (50..<CryptoCacher.global.cachedData.count).map { IndexPath(row: $0, section: 0) }
        
        provideDataSource(coins: CryptoCacher.global.cachedData)
        needToInsertRemainingItems = false
    }

    func prepareAllCryptos() {
        let cryptoAssetsRoute = GetCryptoAssetsParams()
        
        isLoading.send(true)
        
        inputs.getCryptoAssetsService.fetch(route: cryptoAssetsRoute)
            .receive(on: RunLoop.main)
            .sink { [ weak self ] completion in
                self?.isLoading.send(false)
                if case let .failure(error) = completion {
                    self?.provideDataSource(coins: [])
                    self?.error.send(error)
                }
            } receiveValue: { [ weak self ] assetsResponse in
                let coins = assetsResponse.data.all.map { return CryptoPickerItemCellModel.CoinInfo(name: $0.name,
                                                                                                    abbriviation: $0.coin,
                                                                                                    iconPath: $0.iconPath,
                                                                                                    balance: $0.balance) }
                self?.coins = coins
                self?.provideDataSource(coins: coins)
            }
            .store(in: &cancellables)
    }

    func provideDataSource(coins: [CryptoPickerItemCellModel.CoinInfo]) {
        guard !coins.isEmpty else {
            dataSource.send([])

            return
        }
        
        let section = provideSection(with: "",
                                     and: coins)

        self.dataSource.send([section])
    }
    
    private func provideSection(with title: String, and data: [CryptoPickerItemCellModel.CoinInfo]) -> CryptoPickerSection {
        let headerModel = TitledTableHeaderAndFooterViewModel(title: title,
                                                              font: ThemeProvider.currentTheme.fonts.regular(ofSize: 19, family: .rubik),
                                                              backgroundColor: ThemeProvider.currentTheme.colors.mainWhite)
        
        let cellModels = data.map {
            CryptoPickerItemCellModel(cryptoMainInfo: $0)
        }

        return CryptoPickerSection(headerModel: headerModel, cellModels: cellModels)
    }
    
    // MARK: - Binding
    
    private func bindToSearchTerm() {
        headerViewModel.searchTerm
            .sink { [ weak self ] term in
                guard let self else { return }
                
                guard let term,
                      !term.isEmpty else {
                    self.provideDataSource(coins: self.coins)

                    return
                }
                
                let filterdCryptoData = self.provideCryptoAssetResponse(from: term)
                self.provideDataSource(coins: filterdCryptoData)
            }
            .store(in: &cancellables)
    }
    
    private func bindToSearchCancelling() {
        headerViewModel.searchCancelPublisher
            .sink { [ weak self ] in
                guard let self else { return }
                
                self.provideDataSource(coins: self.coins)
            }
            .store(in: &cancellables)
    }
    
    private func bindToSearchingState() {
        headerViewModel.isSearchActive
            .sink { [ weak self ] isActive in
                guard let self else { return }

                let title = isActive || self.headerViewModel.hasTerm ? Constants.Localization.CryptoAccount.emptyStateTitle
                                     : Constants.Localization.Common.errorMessage
                self.emptyStateModel.title.send(title)
            }
            .store(in: &cancellables)
    }

    private func provideCryptoAssetResponse(from term: String) -> [CryptoPickerItemCellModel.CoinInfo] {
        let a = coins.filter {
            $0.name.lowercased().contains(term.lowercased())
                                    || $0.abbriviation.lowercased().contains(term.lowercased())
        }

        return a
    }
}
