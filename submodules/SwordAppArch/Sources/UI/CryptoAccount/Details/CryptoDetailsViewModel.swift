//
//  CryptoDetailsViewModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 09.03.23.
//

import Combine
import Foundation
import SwordCharts

struct CryptoDetailsViewModelInputs {
    let getCryptoChartDataService: GetCryptoChartDataServicing
    let getAssetItemInfoService: GetAssetItemInfoServicing
}

final class CryptoDetailsViewModel: BaseViewModel<CryptoDetailsViewModelInputs>, StackViewModeling {
    var setupModel: CurrentValueSubject<CryptoDetailsStackViewModel?, Never>

    let allCryptos: GetCryptoAssetsResponse
    let cryptoInfo: CryptoModel
    let mainCoinInfo: AppMainCoinInfo
    var cryptoAccountInfoDidChange: Bool = false

    let isConvertableCoin: PassthroughSubject<Bool, Never> = PassthroughSubject()
    
    let klineDataPublisher: PassthroughSubject<Any, Never> = PassthroughSubject()
    
    lazy var infoButtonPublisher: PassthroughSubject<Void, Never>? = {
        return setupModel.value?.cryptoInfoSetupModel.infoButtonPublisher
    }()

    init(inputs: CryptoDetailsViewModelInputs,
         cryptoInfo: CryptoModel,
         allCryptos: GetCryptoAssetsResponse,
         mainCoinInfo: AppMainCoinInfo) {
        self.mainCoinInfo = mainCoinInfo
        self.allCryptos = allCryptos
        self.cryptoInfo = cryptoInfo
        self.setupModel = CurrentValueSubject(.init(cryptoInfo: cryptoInfo))

        super.init(inputs: inputs)

        bindToSelectedInterval()
        bindToKLineDataPublisher()
        bindToCryptoAccountInfoChangingNotification()
    }
    
    
    func fetchCryptoInfo() {
        let route = GetAssetItemInfoParams(coin: cryptoInfo.abbreviation)
        
        isLoading.send(true)
        
        inputs.getAssetItemInfoService.fetch(route: route)
            .receive(on: RunLoop.main)
            .sink { [ weak self ] completion in
                self?.isLoading.send(false)
                self?.cryptoAccountInfoDidChange = false

                if case let .failure(error) = completion {
                    self?.error.send(error)
                }
            } receiveValue: { [ weak self ] response in
                guard let self else { return }

                if let balance = response.data.balance {
                    self.cryptoInfo.accountInfo?.balance.send(balance)
                    self.cryptoInfo.accountInfo?.balanceInEuro.send(balance * self.cryptoInfo.priceInEuro.value)
                }
            }
            .store(in: &cancellables)
    }
    
    func provideAllConvertableCoins() -> GetCryptoAssetsResponse {
        return GetCryptoAssetsResponse(userCryptos: filterCryptoInfo(allCryptos.userCryptos,
                                                                     convertableCryptos: []),
                                       topCryptos: filterCryptoInfo(allCryptos.topCryptos,
                                                                    convertableCryptos: []),
                                       availableCryptos: filterCryptoInfo(allCryptos.availableCryptos,
                                                                          convertableCryptos: []),
                                       mainCoin: allCryptos.mainCoin)
    }

    private func fetchChartData(interval: ChartDataInterval) {
        guard let startTime = interval.startTime else { return }
        let symbol: String
        
        if cryptoInfo.abbreviation == mainCoinInfo.name {
            symbol = "EUR\(cryptoInfo.abbreviation)"
        } else {
            symbol = "\(cryptoInfo.abbreviation)\(mainCoinInfo.name)"
        }
        
        let route = GetCryptoChartDataParams(symbol: symbol,
                                             startTime: startTime * 1000,
                                             interval: interval.streamInterval)

        inputs.getCryptoChartDataService.fetch(route: route)
            .receive(on: RunLoop.main)
            .sink { [ weak self ] completion in
                guard let self else { return }
                
                if case let .failure(error) = completion {
                    print("Failed to fetch chart data for coin \(self.cryptoInfo.abbreviation), in interval \(interval)")
                    print("Error is \(error.localizedDescription)")
                } else {
                    print("Chart Data fetched successfully")
                }
            } receiveValue: { [ weak self ] chartData in
                self?.handleChartData(chartData)
            }.store(in: &cancellables)
    }

    private func updateToChartDataChangeSubscriptionState(for interval: ChartDataInterval) {
        let shouldSubscribe = interval == .oneDay
        
        shouldSubscribe ? WebSocketManager.global.addSubscriber(klineDataPublisher, for: .kline)
                        : WebSocketManager.global.removeSubscriber(of: .kline)

        subscribeToKLine(force: shouldSubscribe, interval: interval.streamInterval)
    }
    
    func subscribeToKLine(force toSubscribe: Bool, interval: String) {
        let method = toSubscribe ? "SUBSCRIBE" : "UNSUBSCRIBE"
        let symbol: String
        
        if cryptoInfo.abbreviation == mainCoinInfo.name {
            symbol = "eur\(cryptoInfo.abbreviation.lowercased())"
        } else {
            symbol = "\(cryptoInfo.abbreviation.lowercased())\(mainCoinInfo.name.lowercased())"
        }
        
        let params = "\(symbol)@kline_\(interval)"
        let dict: [String: Any] = [
                                    "method": method,
                                    "params": [params],
                                    "id": 35 //TODO: - Create kind of enum for this ids
                                  ]

        WebSocketManager.global.sendData(dict)
    }

    private func filterCryptoInfo(_ info: [GetCryptoAssetsResponse.CryptoMainInfo],
                                  convertableCryptos: [String]) -> [GetCryptoAssetsResponse.CryptoMainInfo] {
        return info.filter { convertableCryptos.contains($0.coin) }
    }

    // MARK: - Chart
    
    private func handleChartData(_ chartData: [GetCryptoChartDataResponse]) {
        let newChartData: [ChartDataEntry] = chartData.compactMap {
            guard var doubledPrice = Double($0.price) else { return nil }
            if doubledPrice != 0 && cryptoInfo.abbreviation == mainCoinInfo.name {
                doubledPrice = 1 / doubledPrice
            }
            let multiplier = cryptoInfo.abbreviation == mainCoinInfo.name ? 1 : mainCoinInfo.price
            let dataEntry = ChartDataEntry(x: $0.openTime, y: doubledPrice * multiplier)

            return dataEntry
        }

        setupModel.value?.chartData.send(newChartData)
    }

    // MARK: - Binding
    
    private func bindToSelectedInterval() {
        setupModel.value?.selectedInterval
            .debounce(for: .seconds(0.25), scheduler: DispatchQueue.main)
            .sink { selectedInterval in
                self.fetchChartData(interval: selectedInterval)
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

    private func bindToKLineDataPublisher() {
        klineDataPublisher
            .receive(on: RunLoop.main)
            .sink { [ weak self ] data in
                guard let self,
                      let setupModel = self.setupModel.value,
                      let model = data as? KLineSocketResponse,
                      var doubledAmount = Double(model.data.price) else { return }

                if !doubledAmount.isZero && self.cryptoInfo.abbreviation == self.mainCoinInfo.name {
                    doubledAmount = 1 / doubledAmount
                }

                let multiplier = self.cryptoInfo.abbreviation == self.mainCoinInfo.name ? 1 : self.mainCoinInfo.price
                var existingChartData = setupModel.chartData.value
                let newDataEntry = ChartDataEntry(x: model.data.startTime,
                                                  y: doubledAmount * multiplier)
                
                if !existingChartData.isEmpty {
                    existingChartData.removeFirst()
                }
                existingChartData.append(newDataEntry)

                setupModel.chartData.send(existingChartData)
            }
            .store(in: &cancellables)
    }
    
    deinit {
        subscribeToKLine(force: false, interval: ChartDataInterval.oneDay.rawValue)
    }
}
