//
//  BuyOrSellCryptoViewControllerAssembly.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 09.03.23.
//

import Swinject
import Foundation

final class BuyOrSellCryptoViewControllerAssembly: Assembly {
    let cryptoActionModel: CryptoActionModel
    
    init(cryptoActionModel: CryptoActionModel) {
        self.cryptoActionModel = cryptoActionModel
    }

    func assemble(container: Container) {
        let cryptoActionModel = self.cryptoActionModel

        container.register(BuyOrSellCryptoViewModel.self) { resolver in
            let tradeInfoService = resolver.resolve(CryptoTradeInfoServicing.self)!
            let buyCryptoService = resolver.resolve(BuyCryptoServicing.self)!
            let sellCryptoService = resolver.resolve(SellCryptoServicing.self)!
            
            let inputs = BuyOrSellCryptoViewModelInputs(tradeInfoService: tradeInfoService,
                                                        buyCryptoService: buyCryptoService,
                                                        sellCryptoService: sellCryptoService)
            
            return BuyOrSellCryptoViewModel(inputs: inputs, cryptoActionModel: cryptoActionModel)
        }

        container.register(BuyOrSellCryptoViewController.self) { resolver in
            let viewModel = resolver.resolve(BuyOrSellCryptoViewModel.self)!
            let viewController = BuyOrSellCryptoViewController(viewModel: viewModel)

            return viewController
        }
    }
}
