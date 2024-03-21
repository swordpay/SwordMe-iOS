//
//  VerifyEmailTokenService.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 10.05.23.
//

import Combine
import Swinject
import Foundation

public protocol VerifyEmailTokenServicing {
    func fetch(route: VerifyEmailTokenParams) -> AnyPublisher<SingleItemBaseResponse<VerifyEmailTokenResponse>, Error>
}

final class VerifyEmailTokenWebService: Service, VerifyEmailTokenServicing {
    func fetch(route: VerifyEmailTokenParams) -> AnyPublisher<SingleItemBaseResponse<VerifyEmailTokenResponse>, Error> {
        return call(route: route)
    }
}

final class VerifyEmailTokenMockService: Service, VerifyEmailTokenServicing {
    func fetch(route: VerifyEmailTokenParams) -> AnyPublisher<SingleItemBaseResponse<VerifyEmailTokenResponse>, Error> {
        return call(route: route)
    }
}

public final class VerifyEmailTokenServiceAssembly: Assembly {
    public init() {
        
    }

    public func assemble(container: Container) {
        container.register(VerifyEmailTokenServicing.self) { _ in
            if AppEnvironment.current == .mock {
                return VerifyEmailTokenMockService(dataFetchManager: DataFetchManagerProvider.mock)
            } else {
                return VerifyEmailTokenWebService(dataFetchManager: DataFetchManagerProvider.web)
            }
        }
    }
}
