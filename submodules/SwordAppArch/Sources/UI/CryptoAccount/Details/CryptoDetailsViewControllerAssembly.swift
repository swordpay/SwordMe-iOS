//
//  CryptoDetailsViewControllerAssembly.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 09.03.23.
//

import Swinject
import Foundation

final class CryptoDetailsViewControllerAssembly: Assembly {
    let allCryptos: GetCryptoAssetsResponse
    let cryptoInfo: CryptoModel
    let mainCoinInfo: AppMainCoinInfo

    init(allCryptos: GetCryptoAssetsResponse,
         cryptoInfo: CryptoModel,
         mainCoinInfo: AppMainCoinInfo) {
        self.allCryptos = allCryptos
        self.cryptoInfo = cryptoInfo
        self.mainCoinInfo = mainCoinInfo
    }

    func assemble(container: Container) {
        let cryptoInfo = self.cryptoInfo
        let allCryptos = self.allCryptos
        let mainCoinInfo = self.mainCoinInfo
        
        container.register(CryptoDetailsViewModel.self) { resolver in
            let getCryptoChartDataService = resolver.resolve(GetCryptoChartDataServicing.self)!
            let getAssetItemInfoService = resolver.resolve(GetAssetItemInfoServicing.self)!

            let inputs = CryptoDetailsViewModelInputs(getCryptoChartDataService: getCryptoChartDataService,
                                                      getAssetItemInfoService: getAssetItemInfoService)
            
            return CryptoDetailsViewModel(inputs: inputs,
                                          cryptoInfo: cryptoInfo,
                                          allCryptos: allCryptos,
                                          mainCoinInfo: mainCoinInfo)
        }

        container.register(CryptoDetailsViewController.self) { resolver in
            let viewModel = resolver.resolve(CryptoDetailsViewModel.self)!
            let viewController = CryptoDetailsViewController(viewModel: viewModel)
            
            return viewController
        }
    }
}
