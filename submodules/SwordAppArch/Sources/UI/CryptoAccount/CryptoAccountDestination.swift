//
//  CryptoAccountDestination.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 20.12.22.
//


import UIKit
import Combine

final class CryptoAccountDestinationProvider {
    private static var cachedController: [Int: UIViewController] = [:]
    
    static func viewController(for destination: CryptoAccountDestination) -> UIViewController {
        if let cachedController = cachedController[destination.id] {
            return cachedController
        }

        let controller: UIViewController

        switch destination {
        case .cryptoPicker(let coins, let selectedCrypto):
            controller = ViewControllerProvider.CryptoAccount.cryptoPicker(coins: coins,
                                                                     selectedCrypto: selectedCrypto)
        case .details(let allCryptos, let cryptoInfo, let mainCoinInfo):
            controller = ViewControllerProvider.CryptoAccount.cryptoDetails(allCryptos: allCryptos,
                                                                      cryptoInfo: cryptoInfo,
                                                                      mainCoinInfo: mainCoinInfo)
        case .buyOrSell(let cryptoActionModel):
            controller = ViewControllerProvider.CryptoAccount.buyOrSellCrypto(cryptoActionModel: cryptoActionModel)
        }

        cachedController[destination.id] = controller

        return controller
    }

    static func removeCachedViewControlelrs(for destination: CryptoAccountDestination) {
        cachedController.removeValue(forKey: destination.id)
    }
}

enum CryptoAccountDestination: Destinationing {
    case cryptoPicker(coins: [CryptoPickerItemCellModel.CoinInfo],
                      selectedCrypto: CurrentValueSubject<CryptoPickerItemCellModel.CoinInfo?, Never>)
    case details(allCryptos: GetCryptoAssetsResponse, cryptoInfo: CryptoModel, mainCoinInfo: AppMainCoinInfo)
    case buyOrSell(cryptoActionModel: CryptoActionModel)
        
    var id: Int {
        switch self {
        case .cryptoPicker:
            return 0
        case .details:
            return 1
        case .buyOrSell:
            return 2
        }
    }
    
    var viewController: UIViewController {
        return CryptoAccountDestinationProvider.viewController(for: self)
    }


    var navigationType: NavigationType {
        switch self {
        case .cryptoPicker:
            return .modal(presentationMode: .pageSheet)
        default:
            return .push(animated: true)
        }
    }
}
