//
//  GetUserByUsernameService.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 31.03.23.
//

import Combine
import Swinject
import Foundation

public protocol GetUserByUsernameServicing {
    func fetch(route: GetUserByUsernameParams) -> AnyPublisher<GetUserByUsernameResponse, Error>
}

public final class GetUserByUsernameWebService: Service, GetUserByUsernameServicing {
    public func fetch(route: GetUserByUsernameParams) -> AnyPublisher<GetUserByUsernameResponse, Error> {
        return call(route: route)
    }
}

public final class GetUserByUsernameMockService: Service, GetUserByUsernameServicing {
    public func fetch(route: GetUserByUsernameParams) -> AnyPublisher<GetUserByUsernameResponse, Error> {
        return call(route: route)
    }
}

public final class GetUserByUsernameServiceAssembly: Assembly {
    public init() {
        
    }

    public func assemble(container: Container) {
        container.register(GetUserByUsernameServicing.self) { _ in
            if AppEnvironment.current == .mock {
                return GetUserByUsernameMockService(dataFetchManager: DataFetchManagerProvider.mock)
            } else {
                return GetUserByUsernameWebService(dataFetchManager: DataFetchManagerProvider.web)
            }
        }
    }
}
