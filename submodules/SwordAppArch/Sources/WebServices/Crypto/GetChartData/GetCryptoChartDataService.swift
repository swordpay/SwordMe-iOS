//
//  GetCryptoChartDataService.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 23.03.23.
//

import Combine
import Swinject
import Foundation

protocol GetCryptoChartDataServicing {
    func fetch(route: GetCryptoChartDataParams) -> AnyPublisher<Array<GetCryptoChartDataResponse>, Error>
}

final class GetCryptoChartDataWebService: Service, GetCryptoChartDataServicing {
    func fetch(route: GetCryptoChartDataParams) -> AnyPublisher<Array<GetCryptoChartDataResponse>, Error> {
        return call(route: route)
    }
}

final class GetCryptoChartDataMockService: Service, GetCryptoChartDataServicing {
    func fetch(route: GetCryptoChartDataParams) -> AnyPublisher<Array<GetCryptoChartDataResponse>, Error> {
        return call(route: route)
    }
}

final class GetCryptoChartDataServiceAssembly: Assembly {
    func assemble(container: Container) {
        container.register(GetCryptoChartDataServicing.self) { _ in
            if AppEnvironment.current == .mock {
                return GetCryptoChartDataMockService(dataFetchManager: DataFetchManagerProvider.mock)
            } else {
                return GetCryptoChartDataWebService(dataFetchManager: DataFetchManagerProvider.web)
            }
        }
    }
}
