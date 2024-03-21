//
//  BuyCryptoService.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 20.03.23.
//

import Combine
import Swinject
import Foundation

protocol BuyCryptoServicing {
    func fetch(route: BuyCryptoParams) -> AnyPublisher<SingleItemBaseResponse<BuyCryptoResponse>, Error>
}

final class BuyCryptoWebService: Service, BuyCryptoServicing {
    func fetch(route: BuyCryptoParams) -> AnyPublisher<SingleItemBaseResponse<BuyCryptoResponse>, Error> {
        return call(route: route)
    }
}

final class BuyCryptoMockService: Service, BuyCryptoServicing {
    func fetch(route: BuyCryptoParams) -> AnyPublisher<SingleItemBaseResponse<BuyCryptoResponse>, Error> {
        return call(route: route)
    }
}

final class BuyCryptoServiceAssembly: Assembly {
    func assemble(container: Container) {
        container.register(BuyCryptoServicing.self) { _ in
            if AppEnvironment.current == .mock {
                return BuyCryptoMockService(dataFetchManager: DataFetchManagerProvider.mock)
            } else {
                return BuyCryptoWebService(dataFetchManager: DataFetchManagerProvider.web)
            }
        }
    }
}
