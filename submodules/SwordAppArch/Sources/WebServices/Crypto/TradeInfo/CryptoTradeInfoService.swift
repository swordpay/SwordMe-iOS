//
//  CryptoTradeInfoService.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 19.03.23.
//

import Combine
import Swinject
import Foundation

protocol CryptoTradeInfoServicing {
    func fetch(route: CryptoTradeInfoParams) -> AnyPublisher<CryptoTradeInfoResponse, Error>
}

final class CryptoTradeInfoWebService: Service, CryptoTradeInfoServicing {
    func fetch(route: CryptoTradeInfoParams) -> AnyPublisher<CryptoTradeInfoResponse, Error> {
        return call(route: route)
    }
}

final class CryptoTradeInfoMockService: Service, CryptoTradeInfoServicing {
    func fetch(route: CryptoTradeInfoParams) -> AnyPublisher<CryptoTradeInfoResponse, Error> {
        return call(route: route)
    }
}

final class CryptoTradeInfoServiceAssembly: Assembly {
    func assemble(container: Container) {
        container.register(CryptoTradeInfoServicing.self) { _ in
            if AppEnvironment.current == .mock {
                return CryptoTradeInfoMockService(dataFetchManager: DataFetchManagerProvider.mock)
            } else {
                return CryptoTradeInfoWebService(dataFetchManager: DataFetchManagerProvider.web)
            }
        }
    }
}
