//
//  MakePaymentService.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 31.03.23.
//

import Combine
import Swinject
import Foundation

protocol MakePaymentServicing {
    func fetch(route: MakePaymentRouting) -> AnyPublisher<SingleItemBaseResponse<MakePaymentResponse>, Error>
}

final class MakePaymentWebService: Service, MakePaymentServicing {
    func fetch(route: MakePaymentRouting) -> AnyPublisher<SingleItemBaseResponse<MakePaymentResponse>, Error> {
        return call(route: route)
    }
}

final class MakePaymentMockService: Service, MakePaymentServicing {
    func fetch(route: MakePaymentRouting) -> AnyPublisher<SingleItemBaseResponse<MakePaymentResponse>, Error> {
        return call(route: route)
    }
}

final class MakePaymentServiceAssembly: Assembly {
    func assemble(container: Container) {
        container.register(MakePaymentServicing.self) { _ in
            if AppEnvironment.current == .mock {
                return MakePaymentMockService(dataFetchManager: DataFetchManagerProvider.mock)
            } else {
                return MakePaymentWebService(dataFetchManager: DataFetchManagerProvider.web)
            }
        }
    }
}
