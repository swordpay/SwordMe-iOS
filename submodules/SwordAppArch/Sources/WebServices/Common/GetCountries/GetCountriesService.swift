//
//  GetCountriesService.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 23.01.23.
//

import Combine
import Swinject
import Foundation

public protocol GetCountriesServicing {
    func fetch(route: GetCountriesParams) -> AnyPublisher<GetCountriesResponse, Error>
}

public final class GetCountriesWebService: Service, GetCountriesServicing {
    public func fetch(route: GetCountriesParams) -> AnyPublisher<GetCountriesResponse, Error> {
        return call(route: route)
    }
}

public final class GetCountriesMockService: Service, GetCountriesServicing {
    public func fetch(route: GetCountriesParams) -> AnyPublisher<GetCountriesResponse, Error> {
        return call(route: route)
    }
}

public final class GetCountriesServiceAssembly: Assembly {
    public func assemble(container: Container) {
        container.register(GetCountriesServicing.self) { _ in
            if AppEnvironment.current == .mock {
                return GetCountriesMockService(dataFetchManager: DataFetchManagerProvider.mock)
            } else {
                return GetCountriesWebService(dataFetchManager: DataFetchManagerProvider.web)
            }
        }
    }
}
