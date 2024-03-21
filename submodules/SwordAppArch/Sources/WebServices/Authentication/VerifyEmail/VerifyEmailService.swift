//
//  VerifyEmailService.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 10.05.23.
//

import Combine
import Swinject
import Foundation

protocol VerifyEmailServicing {
    func fetch(route: VerifyEmailParams) -> AnyPublisher<SingleItemBaseResponse<VerifyEmailResponse>, Error>
}

final class VerifyEmailWebService: Service, VerifyEmailServicing {
    func fetch(route: VerifyEmailParams) -> AnyPublisher<SingleItemBaseResponse<VerifyEmailResponse>, Error> {
        return call(route: route)
    }
}

final class VerifyEmailMockService: Service, VerifyEmailServicing {
    func fetch(route: VerifyEmailParams) -> AnyPublisher<SingleItemBaseResponse<VerifyEmailResponse>, Error> {
        return call(route: route)
    }
}

final class VerifyEmailServiceAssembly: Assembly {
    func assemble(container: Container) {
        container.register(VerifyEmailServicing.self) { _ in
            if AppEnvironment.current == .mock {
                return VerifyEmailMockService(dataFetchManager: DataFetchManagerProvider.mock)
            } else {
                return VerifyEmailWebService(dataFetchManager: DataFetchManagerProvider.web)
            }
        }
    }
}
