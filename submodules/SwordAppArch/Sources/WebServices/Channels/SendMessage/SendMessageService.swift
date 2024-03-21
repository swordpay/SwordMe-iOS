//
//  SendMessageService.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 29.03.23.
//

import Combine
import Swinject
import Foundation

protocol SendMessageServicing {
    func fetch(route: SendMessageParams) -> AnyPublisher<SingleItemBaseResponse<SendMessageResponse>, Error>
}

final class SendMessageWebService: Service, SendMessageServicing {
    func fetch(route: SendMessageParams) -> AnyPublisher<SingleItemBaseResponse<SendMessageResponse>, Error> {
        return call(route: route)
    }
}

final class SendMessageMockService: Service, SendMessageServicing {
    func fetch(route: SendMessageParams) -> AnyPublisher<SingleItemBaseResponse<SendMessageResponse>, Error> {
        return call(route: route)
    }
}

final class SendMessageServiceAssembly: Assembly {
    func assemble(container: Container) {
        container.register(SendMessageServicing.self) { _ in
            if AppEnvironment.current == .mock {
                return SendMessageMockService(dataFetchManager: DataFetchManagerProvider.mock)
            } else {
                return SendMessageWebService(dataFetchManager: DataFetchManagerProvider.web)
            }
        }
    }
}
