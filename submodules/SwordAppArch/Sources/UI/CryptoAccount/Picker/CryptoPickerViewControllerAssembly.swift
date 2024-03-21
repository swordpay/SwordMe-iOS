//
//  CryptoPickerViewControllerAssembly.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 09.03.23.
//

import Combine
import Swinject
import Foundation

final class CryptoPickerViewControllerAssembly: Assembly {
    let coins: [CryptoPickerItemCellModel.CoinInfo]
    let selectedCrypto: CurrentValueSubject<CryptoPickerItemCellModel.CoinInfo?, Never>

    init(coins: [CryptoPickerItemCellModel.CoinInfo],
         selectedCrypto: CurrentValueSubject<CryptoPickerItemCellModel.CoinInfo?, Never>) {
        self.coins = coins
        self.selectedCrypto = selectedCrypto
    }

    func assemble(container: Container) {
        let coins = self.coins
        let selectedCrypto = self.selectedCrypto

        container.register(CryptoPickerViewModel.self) { resolver in
            let getCryptoAssetsService = resolver.resolve(GetCryptoAssetsServicing.self)!
            
            let inputs = CryptoPickerViewModelInputs(getCryptoAssetsService: getCryptoAssetsService)
            
            return CryptoPickerViewModel(inputs: inputs,
                                         coins: coins,
                                         selectedCrypto: selectedCrypto)
        }

        container.register(CryptoPickerViewController.self) { resolver in
            let viewModel = resolver.resolve(CryptoPickerViewModel.self)!
            let viewController = CryptoPickerViewController(viewModel: viewModel)
            
            return viewController
        }
    }
}
