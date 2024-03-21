//
//  DeactivateUserService.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 10.05.23.
//

import Combine
import Swinject
import Foundation

protocol DeactivateUserServicing {
    func fetch(route: DeactivateUserParams) -> AnyPublisher<SingleItemBaseResponse<DeactivateUserResponse>, Error>
}

final class DeactivateUserWebService: Service, DeactivateUserServicing {
    func fetch(route: DeactivateUserParams) -> AnyPublisher<SingleItemBaseResponse<DeactivateUserResponse>, Error> {
        return call(route: route)
    }
}

final class DeactivateUserMockService: Service, DeactivateUserServicing {
    func fetch(route: DeactivateUserParams) -> AnyPublisher<SingleItemBaseResponse<DeactivateUserResponse>, Error> {
        return call(route: route)
    }
}

final class DeactivateUserServiceAssembly: Assembly {
    func assemble(container: Container) {
        container.register(DeactivateUserServicing.self) { _ in
            if AppEnvironment.current == .mock {
                return DeactivateUserMockService(dataFetchManager: DataFetchManagerProvider.mock)
            } else {
                return DeactivateUserWebService(dataFetchManager: DataFetchManagerProvider.web)
            }
        }
    }
}
