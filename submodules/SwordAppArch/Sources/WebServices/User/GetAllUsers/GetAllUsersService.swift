//
//  GetAllUsersService.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 05.04.23.
//

import Combine
import Swinject
import Foundation

protocol GetAllUsersServicing {
    func fetch(route: GetAllUsersParams) -> AnyPublisher<GetAllUsersResponse, Error>
}

final class GetAllUsersWebService: Service, GetAllUsersServicing {
    func fetch(route: GetAllUsersParams) -> AnyPublisher<GetAllUsersResponse, Error> {
        return call(route: route)
    }
}

final class GetAllUsersMockService: Service, GetAllUsersServicing {
    func fetch(route: GetAllUsersParams) -> AnyPublisher<GetAllUsersResponse, Error> {
        return call(route: route)
    }
}

final class GetAllUsersServiceAssembly: Assembly {
    func assemble(container: Container) {
        container.register(GetAllUsersServicing.self) { _ in
            if AppEnvironment.current == .mock {
                return GetAllUsersMockService(dataFetchManager: DataFetchManagerProvider.mock)
            } else {
                return GetAllUsersWebService(dataFetchManager: DataFetchManagerProvider.web)
            }
        }
    }
}
