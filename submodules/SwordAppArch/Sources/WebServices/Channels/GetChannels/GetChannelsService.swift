//
//  GetChannelsService.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 28.03.23.
//

import Combine
import Swinject
import Foundation

protocol GetChannelsServicing {
    func fetch(route: GetChannelsParams) -> AnyPublisher<GetChannelsResponse, Error>
}

final class GetChannelsWebService: Service, GetChannelsServicing {
    func fetch(route: GetChannelsParams) -> AnyPublisher<GetChannelsResponse, Error> {
        return call(route: route)
    }
}

final class GetChannelsMockService: Service, GetChannelsServicing {
    func fetch(route: GetChannelsParams) -> AnyPublisher<GetChannelsResponse, Error> {
        return call(route: route)
    }
}

final class GetChannelsServiceAssembly: Assembly {
    func assemble(container: Container) {
        container.register(GetChannelsServicing.self) { _ in
            if AppEnvironment.current == .mock {
                return GetChannelsMockService(dataFetchManager: DataFetchManagerProvider.mock)
            } else {
                return GetChannelsWebService(dataFetchManager: DataFetchManagerProvider.web)
            }
        }
    }
}
