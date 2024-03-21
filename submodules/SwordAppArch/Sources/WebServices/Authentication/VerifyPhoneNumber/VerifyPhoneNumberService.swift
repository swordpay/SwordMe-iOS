//
//  VerifyPhoneNumberService.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 07.12.22.
//

import Combine
import Swinject
import Foundation

protocol VerifyPhoneNumberServicing {
    func fetch(route: VerifyPhoneNumberParams) -> AnyPublisher<SingleItemBaseResponse<VerifyPhoneNumberResponse>, Error>
}

final class VerifyPhoneNumberWebService: Service, VerifyPhoneNumberServicing {
    func fetch(route: VerifyPhoneNumberParams) -> AnyPublisher<SingleItemBaseResponse<VerifyPhoneNumberResponse>, Error> {
        return call(route: route)
    }
}

final class VerifyPhoneNumberMockService: Service, VerifyPhoneNumberServicing {
    func fetch(route: VerifyPhoneNumberParams) -> AnyPublisher<SingleItemBaseResponse<VerifyPhoneNumberResponse>, Error> {
        return call(route: route)
    }
}

final class VerifyPhoneNumberServiceAssembly: Assembly {
    func assemble(container: Container) {
        container.register(VerifyPhoneNumberServicing.self) { _ in
            if AppEnvironment.current == .mock {
                return VerifyPhoneNumberMockService(dataFetchManager: DataFetchManagerProvider.mock)
            } else {
                return VerifyPhoneNumberWebService(dataFetchManager: DataFetchManagerProvider.web)
            }
        }
    }
}
