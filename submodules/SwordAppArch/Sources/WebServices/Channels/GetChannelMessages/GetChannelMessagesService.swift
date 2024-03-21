//
//  GetChannelMessagesService.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 29.03.23.
//

import Combine
import Swinject
import Foundation

protocol GetChannelMessagesServicing {
    func fetch(route: GetChannelMessagesParams) -> AnyPublisher<GetChannelMessagesResponse, Error>
}

final class GetChannelMessagesWebService: Service, GetChannelMessagesServicing {
    func fetch(route: GetChannelMessagesParams) -> AnyPublisher<GetChannelMessagesResponse, Error> {
        return call(route: route)
    }
}

final class GetChannelMessagesMockService: Service, GetChannelMessagesServicing {
    func fetch(route: GetChannelMessagesParams) -> AnyPublisher<GetChannelMessagesResponse, Error> {
        return call(route: route)
    }
}

final class GetChannelMessagesServiceAssembly: Assembly {
    func assemble(container: Container) {
        container.register(GetChannelMessagesServicing.self) { _ in
            if AppEnvironment.current == .mock {
                return GetChannelMessagesMockService(dataFetchManager: DataFetchManagerProvider.mock)
            } else {
                return GetChannelMessagesWebService(dataFetchManager: DataFetchManagerProvider.web)
            }
        }
    }
}
