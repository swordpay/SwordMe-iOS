//
//  AssetsPricesChangesService.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 17.03.23.
//

import Combine
import Swinject
import Foundation

protocol AssetsPricesChangesServicing {
    func fetch(route: AssetsPricesChangesParams) -> AnyPublisher<Array<AssetsPricesChangesResponse>, Error>
}

final class AssetsPricesChangesWebService: Service, AssetsPricesChangesServicing {
    func fetch(route: AssetsPricesChangesParams) -> AnyPublisher<Array<AssetsPricesChangesResponse>, Error> {
        return call(route: route)
    }
}

final class AssetsPricesChangesMockService: Service, AssetsPricesChangesServicing {
    func fetch(route: AssetsPricesChangesParams) -> AnyPublisher<Array<AssetsPricesChangesResponse>, Error> {
        return call(route: route)
    }
}

final class AssetsPricesChangesServiceAssembly: Assembly {
    func assemble(container: Container) {
        container.register(AssetsPricesChangesServicing.self) { _ in
            if AppEnvironment.current == .mock {
                return AssetsPricesChangesMockService(dataFetchManager: DataFetchManagerProvider.mock)
            } else {
                return AssetsPricesChangesWebService(dataFetchManager: DataFetchManagerProvider.web)
            }
        }
    }
}
