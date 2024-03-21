//
//  GetCryptoBalanceService.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 13.03.23.
//

import Combine
import Swinject
import Foundation

protocol GetCryptoBalanceServicing {
    func fetch(route: GetCryptoBalanceParams) -> AnyPublisher<SingleItemBaseResponse<GetCryptoBalanceResponse>, Error>
}

final class GetCryptoBalanceWebService: Service, GetCryptoBalanceServicing {
    func fetch(route: GetCryptoBalanceParams) -> AnyPublisher<SingleItemBaseResponse<GetCryptoBalanceResponse>, Error> {
        return call(route: route)
    }
}

final class GetCryptoBalanceMockService: Service, GetCryptoBalanceServicing {
    func fetch(route: GetCryptoBalanceParams) -> AnyPublisher<SingleItemBaseResponse<GetCryptoBalanceResponse>, Error> {
        return call(route: route)
    }
}

final class GetCryptoBalanceServiceAssembly: Assembly {
    func assemble(container: Container) {
        container.register(GetCryptoBalanceServicing.self) { _ in
            if AppEnvironment.current == .mock {
                return GetCryptoBalanceMockService(dataFetchManager: DataFetchManagerProvider.mock)
            } else {
                return GetCryptoBalanceWebService(dataFetchManager: DataFetchManagerProvider.web)
            }
        }
    }
}
