//
//  ResetPasswordService.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 25.01.23.
//

import Combine
import Swinject
import Foundation

protocol ResetPasswordServicing {
    func fetch(route: ResetPasswordParams) -> AnyPublisher<SingleItemBaseResponse<ResetPasswordResponse>, Error>
}

final class ResetPasswordWebService: Service, ResetPasswordServicing {
    func fetch(route: ResetPasswordParams) -> AnyPublisher<SingleItemBaseResponse<ResetPasswordResponse>, Error> {
        return call(route: route)
    }
}

final class ResetPasswordMockService: Service, ResetPasswordServicing {
    func fetch(route: ResetPasswordParams) -> AnyPublisher<SingleItemBaseResponse<ResetPasswordResponse>, Error> {
        return call(route: route)
    }
}

final class ResetPasswordServiceAssembly: Assembly {
    func assemble(container: Container) {
        container.register(ResetPasswordServicing.self) { _ in
            if AppEnvironment.current == .mock {
                return ResetPasswordMockService(dataFetchManager: DataFetchManagerProvider.mock)
            } else {
                return ResetPasswordWebService(dataFetchManager: DataFetchManagerProvider.web)
            }
        }
    }
}
