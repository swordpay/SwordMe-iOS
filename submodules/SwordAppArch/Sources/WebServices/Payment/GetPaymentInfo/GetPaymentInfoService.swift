//
//  GetPaymentInfoService.swift
//  SwordAppArch
//
//  Created by Tigran Simonyan on 24.08.23.
//


import Combine
import Swinject
import Foundation

public protocol GetPaymentInfoServicing {
    func fetch(route: GetPaymentInfoParams) -> AnyPublisher<SingleItemBaseResponse<GetPaymentInfoResponse>, Error>
}

public final class GetPaymentInfoWebService: Service, GetPaymentInfoServicing {
    public func fetch(route: GetPaymentInfoParams) -> AnyPublisher<SingleItemBaseResponse<GetPaymentInfoResponse>, Error> {
        return call(route: route)
    }
}

public final class GetPaymentInfoMockService: Service, GetPaymentInfoServicing {
    public func fetch(route: GetPaymentInfoParams) -> AnyPublisher<SingleItemBaseResponse<GetPaymentInfoResponse>, Error> {
        return call(route: route)
    }
}

public final class GetPaymentInfoServiceAssembly: Assembly {
    public func assemble(container: Container) {
        container.register(GetPaymentInfoServicing.self) { _ in
            if AppEnvironment.current == .mock {
                return GetPaymentInfoMockService(dataFetchManager: DataFetchManagerProvider.mock)
            } else {
                return GetPaymentInfoWebService(dataFetchManager: DataFetchManagerProvider.web)
            }
        }
    }
}
