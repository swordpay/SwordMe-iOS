//
//  GetCryptoAssetsService.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 13.03.23.
//

import Combine
import Swinject
import Foundation

protocol GetCryptoAssetsServicing {
    func fetch(route: GetCryptoAssetsParams) -> AnyPublisher<SingleItemBaseResponse<GetCryptoAssetsResponse>, Error>
}

final class GetCryptoAssetsWebService: Service, GetCryptoAssetsServicing {
    func fetch(route: GetCryptoAssetsParams) -> AnyPublisher<SingleItemBaseResponse<GetCryptoAssetsResponse>, Error> {
        return call(route: route)
    }
}

final class GetCryptoAssetsMockService: Service, GetCryptoAssetsServicing {
    func fetch(route: GetCryptoAssetsParams) -> AnyPublisher<SingleItemBaseResponse<GetCryptoAssetsResponse>, Error> {
        return call(route: route)
    }
}

final class GetCryptoAssetsServiceAssembly: Assembly {
    func assemble(container: Container) {
        container.register(GetCryptoAssetsServicing.self) { _ in
            if AppEnvironment.current == .mock {
                return GetCryptoAssetsMockService(dataFetchManager: DataFetchManagerProvider.mock)
            } else {
                return GetCryptoAssetsWebService(dataFetchManager: DataFetchManagerProvider.web)
            }
        }
    }
}
