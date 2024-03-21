//
//  Service.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 13.04.22.
//

import Foundation
import Combine

public class Service {
    var dataFetchManager: DataFetchManaging

    public init(dataFetchManager: DataFetchManaging) {
        self.dataFetchManager = dataFetchManager
    }

    func call<T: Decodable>(route: Routing) -> AnyPublisher<T, Error> {
        return dataFetchManager.fetch(route: route)
    }

    func callWithoutResult(route: Routing) -> AnyPublisher<Void, Error> {
        return dataFetchManager.fetchWithEmptyResult(route: route)
    }
}
