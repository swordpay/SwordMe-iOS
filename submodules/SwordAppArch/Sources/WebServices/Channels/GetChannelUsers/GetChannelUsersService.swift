//
//  GetChannelUsersService.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 30.05.23.
//

import Combine
import Swinject
import Foundation

protocol GetChannelUsersServicing {
    func fetch(route: GetChannelUsersParams) -> AnyPublisher<GetChannelUsersResponse, Error>
}

final class GetChannelUsersWebService: Service, GetChannelUsersServicing {
    func fetch(route: GetChannelUsersParams) -> AnyPublisher<GetChannelUsersResponse, Error> {
        return call(route: route)
    }
}

final class GetChannelUsersMockService: Service, GetChannelUsersServicing {
    func fetch(route: GetChannelUsersParams) -> AnyPublisher<GetChannelUsersResponse, Error> {
        return call(route: route)
    }
}

final class GetChannelUsersServiceAssembly: Assembly {
    func assemble(container: Container) {
        container.register(GetChannelUsersServicing.self) { _ in
            if AppEnvironment.current == .mock {
                return GetChannelUsersMockService(dataFetchManager: DataFetchManagerProvider.mock)
            } else {
                return GetChannelUsersWebService(dataFetchManager: DataFetchManagerProvider.web)
            }
        }
    }
}
