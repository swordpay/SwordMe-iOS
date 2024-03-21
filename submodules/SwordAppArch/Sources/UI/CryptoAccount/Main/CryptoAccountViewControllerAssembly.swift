//
//  CryptoAccountViewControllerAssembly.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 20.12.22.
//

import Swinject
import Foundation
import AccountContext

final class CryptoAccountViewControllerAssembly: Assembly {
    let context: AccountContext
    
    init(context: AccountContext) {
        self.context = context
    }
    
    func assemble(container: Container) {
        let context = context

        container.register(CryptoAccountViewModel.self) { resolver in
            let downloadManager = resolver.resolve(DataDownloadManaging.self)!
            let getCryptoBalanceService = resolver.resolve(GetCryptoBalanceServicing.self)!
            let getCryptoAssetsService = resolver.resolve(GetCryptoAssetsServicing.self)!
            let assetsPricesChangesService = resolver.resolve(AssetsPricesChangesServicing.self)!
            let getAssetItemInfoService = resolver.resolve(GetAssetItemInfoServicing.self)!
            
            let inputs = CryptoAccountViewModelInputs(downloadManager: downloadManager,
                                                      getCryptoBalanceService: getCryptoBalanceService,
                                                      getCryptoAssetsService: getCryptoAssetsService,
                                                      assetsPricesChangesService: assetsPricesChangesService,
                                                      getAssetItemInfoService: getAssetItemInfoService)
            
            return CryptoAccountViewModel(inputs: inputs)
        }

        container.register(CryptoAccountViewController.self) { resolver in
            let viewModel = resolver.resolve(CryptoAccountViewModel.self)!
            let viewController = CryptoAccountViewController(viewModel: viewModel, context: context)
            
            return viewController
        }
    }
}
