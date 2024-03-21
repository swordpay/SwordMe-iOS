//
//  DeclinePaymentService.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 31.03.23.
//

import Combine
import Swinject
import Foundation

public protocol DeclinePaymentServicing {
    func fetch(route: DeclinePaymentParams) -> AnyPublisher<SingleItemBaseResponse<DeclinePaymentResponse>, Error>
}

public final class DeclinePaymentWebService: Service, DeclinePaymentServicing {
    public func fetch(route: DeclinePaymentParams) -> AnyPublisher<SingleItemBaseResponse<DeclinePaymentResponse>, Error> {
        return call(route: route)
    }
}

public final class DeclinePaymentMockService: Service, DeclinePaymentServicing {
    public func fetch(route: DeclinePaymentParams) -> AnyPublisher<SingleItemBaseResponse<DeclinePaymentResponse>, Error> {
        return call(route: route)
    }
}

public final class DeclinePaymentServiceAssembly: Assembly {
    public func assemble(container: Container) {
        container.register(DeclinePaymentServicing.self) { _ in
            if AppEnvironment.current == .mock {
                return DeclinePaymentMockService(dataFetchManager: DataFetchManagerProvider.mock)
            } else {
                return DeclinePaymentWebService(dataFetchManager: DataFetchManagerProvider.web)
            }
        }
    }
}
