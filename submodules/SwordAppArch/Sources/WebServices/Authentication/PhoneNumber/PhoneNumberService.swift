//
//  PhoneNumberService.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 07.12.22.
//

import Combine
import Swinject
import Foundation

protocol PhoneNumberServicing {
    func fetch(route: PhoneNumberParams) -> AnyPublisher<PhoneNumberResponse, Error>
}

final class PhoneNumberWebService: Service, PhoneNumberServicing {
    func fetch(route: PhoneNumberParams) -> AnyPublisher<PhoneNumberResponse, Error> {
        return call(route: route)
    }
}

final class PhoneNumberMockService: Service, PhoneNumberServicing {
    func fetch(route: PhoneNumberParams) -> AnyPublisher<PhoneNumberResponse, Error> {
        return call(route: route)
    }
}

final class PhoneNumberServiceAssembly: Assembly {
    func assemble(container: Container) {
        container.register(PhoneNumberServicing.self) { _ in
            return PhoneNumberWebService(dataFetchManager: DataFetchManagerProvider.web)
        }
    }
}
