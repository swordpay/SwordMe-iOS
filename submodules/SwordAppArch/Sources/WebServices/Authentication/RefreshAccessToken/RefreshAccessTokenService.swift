//
//  RefreshAccessTokenService.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 25.01.23.
//

import Combine
import Swinject
import Foundation

public protocol RefreshAccessTokenServicing {
    func fetch(route: RefreshAccessTokenParams) -> AnyPublisher<SingleItemBaseResponse<RefreshAccessTokenResponse>, Error>
}

public final class RefreshAccessTokenWebService: Service, RefreshAccessTokenServicing {
    public func fetch(route: RefreshAccessTokenParams) -> AnyPublisher<SingleItemBaseResponse<RefreshAccessTokenResponse>, Error> {
        return call(route: route)
    }
}

public final class RefreshAccessTokenMockService: Service, RefreshAccessTokenServicing {
    public func fetch(route: RefreshAccessTokenParams) -> AnyPublisher<SingleItemBaseResponse<RefreshAccessTokenResponse>, Error> {
        return call(route: route)
    }
}

public final class RefreshAccessTokenServiceAssembly: Assembly {
    public func assemble(container: Container) {
        container.register(RefreshAccessTokenServicing.self) { _ in
            if AppEnvironment.current == .mock {
                return RefreshAccessTokenMockService(dataFetchManager: DataFetchManagerProvider.mock)
            } else {
                return RefreshAccessTokenWebService(dataFetchManager: DataFetchManagerProvider.web)
            }
        }
    }
}
