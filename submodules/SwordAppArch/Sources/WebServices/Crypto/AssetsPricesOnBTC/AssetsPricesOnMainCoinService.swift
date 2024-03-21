//
//  AssetsPricesOnMainCoinService.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 16.03.23.
//

import Combine
import Swinject
import Foundation

protocol AssetsPricesOnMainCoinServicing {
    func fetch(route: AssetsPricesOnMainCoinParams) -> AnyPublisher<Array<AssetsPricesOnMainCoinResponse>, Error>
}

final class AssetsPricesOnMainCoinWebService: Service, AssetsPricesOnMainCoinServicing {
    func fetch(route: AssetsPricesOnMainCoinParams) -> AnyPublisher<Array<AssetsPricesOnMainCoinResponse>, Error> {
        return call(route: route)
    }
}

final class AssetsPricesOnMainCoinMockService: Service, AssetsPricesOnMainCoinServicing {
    func fetch(route: AssetsPricesOnMainCoinParams) -> AnyPublisher<Array<AssetsPricesOnMainCoinResponse>, Error> {
        return call(route: route)
    }
}

final class AssetsPricesOnMainCoinServiceAssembly: Assembly {
    func assemble(container: Container) {
        container.register(AssetsPricesOnMainCoinServicing.self) { _ in
            if AppEnvironment.current == .mock {
                return AssetsPricesOnMainCoinMockService(dataFetchManager: DataFetchManagerProvider.mock)
            } else {
                return AssetsPricesOnMainCoinWebService(dataFetchManager: DataFetchManagerProvider.web)
            }
        }
    }
}
