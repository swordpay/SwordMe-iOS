//
//  SyncContactsService.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 27.03.23.
//

import Combine
import Swinject
import Foundation

protocol SyncContactsServicing {
    func fetch(route: SyncContactsParams) -> AnyPublisher<SyncContactsResponse, Error>
}

final class SyncContactsWebService: Service, SyncContactsServicing {
    func fetch(route: SyncContactsParams) -> AnyPublisher<SyncContactsResponse, Error> {
        return call(route: route)
    }
}

final class SyncContactsMockService: Service, SyncContactsServicing {
    func fetch(route: SyncContactsParams) -> AnyPublisher<SyncContactsResponse, Error> {
        return call(route: route)
    }
}

final class SyncContactsServiceAssembly: Assembly {
    func assemble(container: Container) {
        container.register(SyncContactsServicing.self) { _ in
            if AppEnvironment.current == .mock {
                return SyncContactsMockService(dataFetchManager: DataFetchManagerProvider.mock)
            } else {
                return SyncContactsWebService(dataFetchManager: DataFetchManagerProvider.web)
            }
        }
    }
}
