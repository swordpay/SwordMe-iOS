//
//  GetAssetItemInfoService.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 24.03.23.
//

import Combine
import Swinject
import Foundation

protocol GetAssetItemInfoServicing {
    func fetch(route: GetAssetItemInfoParams) -> AnyPublisher<SingleItemBaseResponse<CryptoItemInfoModel>, Error>
}

final class GetAssetItemInfoWebService: Service, GetAssetItemInfoServicing {
    func fetch(route: GetAssetItemInfoParams) -> AnyPublisher<SingleItemBaseResponse<CryptoItemInfoModel>, Error> {
        return call(route: route)
    }
}

final class GetAssetItemInfoMockService: Service, GetAssetItemInfoServicing {
    func fetch(route: GetAssetItemInfoParams) -> AnyPublisher<SingleItemBaseResponse<CryptoItemInfoModel>, Error> {
        return call(route: route)
    }
}

final class GetAssetItemInfoServiceAssembly: Assembly {
    func assemble(container: Container) {
        container.register(GetAssetItemInfoServicing.self) { _ in
            if AppEnvironment.current == .mock {
                return GetAssetItemInfoMockService(dataFetchManager: DataFetchManagerProvider.mock)
            } else {
                return GetAssetItemInfoWebService(dataFetchManager: DataFetchManagerProvider.web)
            }
        }
    }
}
