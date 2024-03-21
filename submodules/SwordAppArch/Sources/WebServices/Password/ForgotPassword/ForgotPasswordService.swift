//
//  ForgotPasswordService.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 25.01.23.
//

import Combine
import Swinject
import Foundation

protocol ForgotPasswordServicing {
    func fetch(route: ForgotPasswordParams) -> AnyPublisher<SingleItemBaseResponse<ForgotPasswordResponse>, Error>
}

final class ForgotPasswordWebService: Service, ForgotPasswordServicing {
    func fetch(route: ForgotPasswordParams) -> AnyPublisher<SingleItemBaseResponse<ForgotPasswordResponse>, Error> {
        return call(route: route)
    }
}

final class ForgotPasswordMockService: Service, ForgotPasswordServicing {
    func fetch(route: ForgotPasswordParams) -> AnyPublisher<SingleItemBaseResponse<ForgotPasswordResponse>, Error> {
        return call(route: route)
    }
}

final class ForgotPasswordServiceAssembly: Assembly {
    func assemble(container: Container) {
        container.register(ForgotPasswordServicing.self) { _ in
            if AppEnvironment.current == .mock {
                return ForgotPasswordMockService(dataFetchManager: DataFetchManagerProvider.mock)
            } else {
                return ForgotPasswordWebService(dataFetchManager: DataFetchManagerProvider.web)
            }
        }
    }
}
