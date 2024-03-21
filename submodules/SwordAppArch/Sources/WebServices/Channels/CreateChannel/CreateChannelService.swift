//
//  CreateChannelService.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 27.03.23.
//

import Combine
import Swinject
import Foundation

protocol CreateChannelServicing {
    func fetch(route: CreateChannelRouting) -> AnyPublisher<SingleItemBaseResponse<ChannelItemModel>, Error>
}

final class CreateChannelWebService: Service, CreateChannelServicing {
    func fetch(route: CreateChannelRouting) -> AnyPublisher<SingleItemBaseResponse<ChannelItemModel>, Error> {
        return call(route: route)
    }
}

final class CreateChannelMockService: Service, CreateChannelServicing {
    func fetch(route: CreateChannelRouting) -> AnyPublisher<SingleItemBaseResponse<ChannelItemModel>, Error> {
        return call(route: route)
    }
}

final class CreateChannelServiceAssembly: Assembly {
    func assemble(container: Container) {
        container.register(CreateChannelServicing.self) { _ in
            if AppEnvironment.current == .mock {
                return CreateChannelMockService(dataFetchManager: DataFetchManagerProvider.mock)
            } else {
                return CreateChannelWebService(dataFetchManager: DataFetchManagerProvider.web)
            }
        }
    }
}
