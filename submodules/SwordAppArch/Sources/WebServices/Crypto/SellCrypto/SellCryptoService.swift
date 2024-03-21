//
//  SellCryptoService.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 20.03.23.
//

import Combine
import Swinject
import Foundation

protocol SellCryptoServicing {
    func fetch(route: SellCryptoParams) -> AnyPublisher<SingleItemBaseResponse<SellCryptoResponse>, Error>
}

final class SellCryptoWebService: Service, SellCryptoServicing {
    func fetch(route: SellCryptoParams) -> AnyPublisher<SingleItemBaseResponse<SellCryptoResponse>, Error> {
        return call(route: route)
    }
}

final class SellCryptoMockService: Service, SellCryptoServicing {
    func fetch(route: SellCryptoParams) -> AnyPublisher<SingleItemBaseResponse<SellCryptoResponse>, Error> {
        return call(route: route)
    }
}

final class SellCryptoServiceAssembly: Assembly {
    func assemble(container: Container) {
        container.register(SellCryptoServicing.self) { _ in
            if AppEnvironment.current == .mock {
                return SellCryptoMockService(dataFetchManager: DataFetchManagerProvider.mock)
            } else {
                return SellCryptoWebService(dataFetchManager: DataFetchManagerProvider.web)
            }
        }
    }
}
