//
//  URLSessionFetcher.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 12.04.22.
//

import Combine
import Foundation

public final class URLSessionFetcher: DataFetching {
    private let config: URLSessionConfiguration

    public init(config: URLSessionConfiguration) {
        self.config = config
    }

    public func fetch(from route: Routing) -> AnyPublisher<DataFetchResult, Error> {
        URLSession(configuration: config)
            .dataTaskPublisher(for: route.request)
            .mapError { error in
                return DataFetchingError.internalServerError(nil)
            }
            .map { result in DataFetchResult(route: route, data: result.data, response: result.response) }
            .eraseToAnyPublisher()
    }
}
