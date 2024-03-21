//
//  DeleteAvatarService.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 04.04.23.
//

import Combine
import Swinject
import Foundation

protocol DeleteAvatarServicing {
    func fetch(route: DeleteAvatarParams) -> AnyPublisher<DeleteAvatarResponse, Error>
}

final class DeleteAvatarWebService: Service, DeleteAvatarServicing {
    func fetch(route: DeleteAvatarParams) -> AnyPublisher<DeleteAvatarResponse, Error> {
        return call(route: route)
    }
}

final class DeleteAvatarMockService: Service, DeleteAvatarServicing {
    func fetch(route: DeleteAvatarParams) -> AnyPublisher<DeleteAvatarResponse, Error> {
        return call(route: route)
    }
}

final class DeleteAvatarServiceAssembly: Assembly {
    func assemble(container: Container) {
        container.register(DeleteAvatarServicing.self) { _ in
            if AppEnvironment.current == .mock {
                return DeleteAvatarMockService(dataFetchManager: DataFetchManagerProvider.mock)
            } else {
                return DeleteAvatarWebService(dataFetchManager: DataFetchManagerProvider.web)
            }
        }
    }
}
