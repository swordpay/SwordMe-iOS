//
//  EmailCheckService.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 24.01.23.
//

import Combine
import Swinject
import Foundation

protocol EmailCheckServicing {
    func fetch(route: EmailCheckParams) -> AnyPublisher<SingleItemBaseResponse<EmailCheckResponse>, Error>
}

final class EmailCheckWebService: Service, EmailCheckServicing {
    func fetch(route: EmailCheckParams) -> AnyPublisher<SingleItemBaseResponse<EmailCheckResponse>, Error> {
        return call(route: route)
    }
}

final class EmailCheckMockService: Service, EmailCheckServicing {
    func fetch(route: EmailCheckParams) -> AnyPublisher<SingleItemBaseResponse<EmailCheckResponse>, Error> {
        return call(route: route)
    }
}

final class EmailCheckServiceAssembly: Assembly {
    func assemble(container: Container) {
        container.register(EmailCheckServicing.self) { _ in
            if AppEnvironment.current == .mock {
                return EmailCheckMockService(dataFetchManager: DataFetchManagerProvider.mock)
            } else {
                return EmailCheckWebService(dataFetchManager: DataFetchManagerProvider.web)
            }
        }
    }
}
