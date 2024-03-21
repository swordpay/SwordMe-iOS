//
//  GetLatestPaymentsService.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 07.04.23.
//

import Combine
import Swinject
import Foundation

protocol GetLatestPaymentsServicing {
    func fetch(route: GetLatestPaymentsParams) -> AnyPublisher<GetLatestPaymentsResponse, Error>
}

final class GetLatestPaymentsWebService: Service, GetLatestPaymentsServicing {
    func fetch(route: GetLatestPaymentsParams) -> AnyPublisher<GetLatestPaymentsResponse, Error> {
        return call(route: route)
    }
}

final class GetLatestPaymentsMockService: Service, GetLatestPaymentsServicing {
    func fetch(route: GetLatestPaymentsParams) -> AnyPublisher<GetLatestPaymentsResponse, Error> {
        return call(route: route)
    }
}

final class GetLatestPaymentsServiceAssembly: Assembly {
    func assemble(container: Container) {
        container.register(GetLatestPaymentsServicing.self) { _ in
            if AppEnvironment.current == .mock {
                return GetLatestPaymentsMockService(dataFetchManager: DataFetchManagerProvider.mock)
            } else {
                return GetLatestPaymentsWebService(dataFetchManager: DataFetchManagerProvider.web)
            }
        }
    }
}
