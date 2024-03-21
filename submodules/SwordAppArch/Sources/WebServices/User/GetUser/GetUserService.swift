//
//  GetUserService.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 26.01.23.
//

import Combine
import Swinject
import Foundation

public protocol GetUserServicing {
    func fetch(route: GetUserParams) -> AnyPublisher<GetUserResponse, Error>
}

public final class GetUserWebService: Service, GetUserServicing {
    public func fetch(route: GetUserParams) -> AnyPublisher<GetUserResponse, Error> {
        return call(route: route)
    }
}

public final class GetUserMockService: Service, GetUserServicing {
    public func fetch(route: GetUserParams) -> AnyPublisher<GetUserResponse, Error> {
        return call(route: route)
    }
}

public final class GetUserServiceAssembly: Assembly {
    public init() {
        
    }

    public func assemble(container: Container) {
        container.register(GetUserServicing.self) { _ in
            if AppEnvironment.current == .mock {
                return GetUserMockService(dataFetchManager: DataFetchManagerProvider.mock)
            } else {
                return GetUserWebService(dataFetchManager: DataFetchManagerProvider.web)
            }
        }
    }
}
