//
//  CryptoCacher.swift
//  _LocalDebugOptions
//
//  Created by Tigran Simonyan on 14.09.23.
//

import Combine
import Foundation

public final class CryptoCacher {
    var cachedData: [CryptoPickerItemCellModel.CoinInfo] = []

    var balanceResponse: AccountsBalanceResponse?
    var assetsResponse: GetCryptoAssetsResponse?

    private var balanceResponseService: AccountsBalanceServicing = AccountsBalanceWebService(dataFetchManager: DataFetchManagerProvider.web)
    
    private var assetsResponseService: GetCryptoAssetsServicing = GetCryptoAssetsWebService(dataFetchManager: DataFetchManagerProvider.web)
    public static let global: CryptoCacher = {
        struct SingletonWrapper {
            static let singleton = CryptoCacher()
        }

        return SingletonWrapper.singleton
    }()
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {}
    
    func prepareCryptosInfo() {
        resetCache()

        balanceResponseService.fetch(route: .init())
            .combineLatest(assetsResponseService.fetch(route: .init()))
            .receive(on: RunLoop.main)
            .sink { completion in
                print("prepareCryptosInfo completion")
            } receiveValue: { [ weak self ] balanceResponse, assetsResponse in
                self?.balanceResponse = balanceResponse.data
                self?.assetsResponse = assetsResponse.data
            }
            .store(in: &cancellables)
    }
    
    private func resetCache() {
        cachedData = []
        balanceResponse = nil
        assetsResponse = nil
    }
}
