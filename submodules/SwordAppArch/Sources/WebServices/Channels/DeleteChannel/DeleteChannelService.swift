//
//  DeleteChannelService.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 31.05.23.
//

import Combine
import Swinject
import Foundation

protocol DeleteChannelServicing {
    func fetch(route: DeleteChannelParams) -> AnyPublisher<SingleItemBaseResponse<DeleteChannelResponse>, Error>
}

final class DeleteChannelWebService: Service, DeleteChannelServicing {
    func fetch(route: DeleteChannelParams) -> AnyPublisher<SingleItemBaseResponse<DeleteChannelResponse>, Error> {
        return call(route: route)
    }
}

final class DeleteChannelMockService: Service, DeleteChannelServicing {
    func fetch(route: DeleteChannelParams) -> AnyPublisher<SingleItemBaseResponse<DeleteChannelResponse>, Error> {
        return call(route: route)
    }
}

final class DeleteChannelServiceAssembly: Assembly {
    func assemble(container: Container) {
        container.register(DeleteChannelServicing.self) { _ in
            if AppEnvironment.current == .mock {
                return DeleteChannelMockService(dataFetchManager: DataFetchManagerProvider.mock)
            } else {
                return DeleteChannelWebService(dataFetchManager: DataFetchManagerProvider.web)
            }
        }
    }
}
