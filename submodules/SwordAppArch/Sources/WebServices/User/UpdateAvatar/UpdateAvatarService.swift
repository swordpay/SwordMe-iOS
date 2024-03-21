//
//  UpdateAvatarService.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 04.04.23.
//

import Combine
import Swinject
import Foundation

protocol UpdateAvatarServicing {
    func fetch(route: UpdateAvatarParams) -> AnyPublisher<UpdateAvatarResponse, Error>
}

final class UpdateAvatarWebService: Service, UpdateAvatarServicing {
    func fetch(route: UpdateAvatarParams) -> AnyPublisher<UpdateAvatarResponse, Error> {
        return call(route: route)
    }
}

final class UpdateAvatarMockService: Service, UpdateAvatarServicing {
    func fetch(route: UpdateAvatarParams) -> AnyPublisher<UpdateAvatarResponse, Error> {
        return call(route: route)
    }
}

final class UpdateAvatarServiceAssembly: Assembly {
    func assemble(container: Container) {
        container.register(UpdateAvatarServicing.self) { _ in
            if AppEnvironment.current == .mock {
                return UpdateAvatarMockService(dataFetchManager: DataFetchManagerProvider.mock)
            } else {
                return UpdateAvatarWebService(dataFetchManager: DataFetchManagerProvider.web)
            }
        }
    }
}
