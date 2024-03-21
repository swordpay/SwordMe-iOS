//
//  ChannelPaymentViewControllerAssembly.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 26.12.22.
//

import Combine
import Swinject
import Foundation
import AccountContext

final class ChannelPaymentViewControllerAssembly: Assembly {
    let stateInfo: PayOrRequestStateInfoModel
    let context: AccountContext

    init(stateInfo: PayOrRequestStateInfoModel, context: AccountContext) {
        self.stateInfo = stateInfo
        self.context = context
    }
    
    func assemble(container: Container) {
        let stateInfo = self.stateInfo
        let context = self.context

        container.register(ChannelPaymentViewModel.self) { resolver in
            let downloadManager = resolver.resolve(DataDownloadManaging.self)!
            let accountsBalanceService = resolver.resolve(AccountsBalanceServicing.self)!
            let getCryptoAssetsService = resolver.resolve(GetCryptoAssetsServicing.self)!
            let makePaymentService = resolver.resolve(MakePaymentServicing.self)!
            let assetsPricesChangesService = resolver.resolve(AssetsPricesChangesServicing.self)!

            let inputs = ChannelPaymentViewModelInputs(downloadManager: downloadManager,
                                                       accountsBalanceService: accountsBalanceService,
                                                       getCryptoAssetsService: getCryptoAssetsService,
                                                       makePaymentService: makePaymentService,
                                                       assetsPricesChangesService: assetsPricesChangesService)

            return ChannelPaymentViewModel(inputs: inputs,
                                           stateInfo: stateInfo,
                                           context: context)
        }

        container.register(ChannelPaymentViewController.self) { resolver in
            let viewModel = resolver.resolve(ChannelPaymentViewModel.self)!
            let viewController = ChannelPaymentViewController(viewModel: viewModel, context: context)

            return viewController
        }
    }
}
