//
//  ChangePasswordService.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 11.04.23.
//

import Combine
import Swinject
import Foundation

protocol ChangePasswordServicing {
    func fetch(route: ChangePasswordParams) -> AnyPublisher<SingleItemBaseResponse<ChangePasswordResponse>, Error>
}

final class ChangePasswordWebService: Service, ChangePasswordServicing {
    func fetch(route: ChangePasswordParams) -> AnyPublisher<SingleItemBaseResponse<ChangePasswordResponse>, Error> {
        return call(route: route)
    }
}

final class ChangePasswordMockService: Service, ChangePasswordServicing {
    func fetch(route: ChangePasswordParams) -> AnyPublisher<SingleItemBaseResponse<ChangePasswordResponse>, Error> {
        return call(route: route)
    }
}

final class ChangePasswordServiceAssembly: Assembly {
    func assemble(container: Container) {
        container.register(ChangePasswordServicing.self) { _ in
            if AppEnvironment.current == .mock {
                return ChangePasswordMockService(dataFetchManager: DataFetchManagerProvider.mock)
            } else {
                return ChangePasswordWebService(dataFetchManager: DataFetchManagerProvider.web)
            }
        }
    }
}
