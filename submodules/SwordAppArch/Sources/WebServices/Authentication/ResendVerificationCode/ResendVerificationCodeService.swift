//
//  ResendVerificationCodeService.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 24.01.23.
//

import Combine
import Swinject
import Foundation

protocol ResendVerificationCodeServicing {
    func fetch(route: ResendVerificationCodeParams) -> AnyPublisher<SingleItemBaseResponse<ResendVerificationCodeResponse>, Error>
}

final class ResendVerificationCodeWebService: Service, ResendVerificationCodeServicing {
    func fetch(route: ResendVerificationCodeParams) -> AnyPublisher<SingleItemBaseResponse<ResendVerificationCodeResponse>, Error> {
        return call(route: route)
    }
}

final class ResendVerificationCodeMockService: Service, ResendVerificationCodeServicing {
    func fetch(route: ResendVerificationCodeParams) -> AnyPublisher<SingleItemBaseResponse<ResendVerificationCodeResponse>, Error> {
        return call(route: route)
    }
}

final class ResendVerificationCodeServiceAssembly: Assembly {
    func assemble(container: Container) {
        container.register(ResendVerificationCodeServicing.self) { _ in
            if AppEnvironment.current == .mock {
                return ResendVerificationCodeMockService(dataFetchManager: DataFetchManagerProvider.mock)
            } else {
                return ResendVerificationCodeWebService(dataFetchManager: DataFetchManagerProvider.web)
            }
        }
    }
}
