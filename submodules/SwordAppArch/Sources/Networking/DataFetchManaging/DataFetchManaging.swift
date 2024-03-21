//
//  DataFetchManaging.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 13.04.22.
//

import Foundation
import Combine

public protocol DataFetchManaging {
    var fetcher: DataFetching { get }
    var validator: DataFetchValidating { get }
    var parser: DataParsing { get }

    init(fetcher: DataFetching, validator: DataFetchValidating, parser: DataParsing)

    func fetch<T: Decodable>(route: Routing) -> AnyPublisher<T, Error>
    func fetchWithEmptyResult(route: Routing) -> AnyPublisher<Void, Error>
}
