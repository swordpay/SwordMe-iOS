//
//  DataFetching.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 12.04.22.
//

import Combine
import Foundation

public protocol DataFetching {
    func fetch(from route: Routing) -> AnyPublisher<DataFetchResult, Error>
}

public enum DataFetchingError: Error {
    case unacceptableStatusCode(Routing, URLResponse)
    case binanceError
    case missingJSON(String)
    case inaccessibleData(String, Error)
    case internalServerError(String?)
    case authorizationExpired
    case appAccessBlocked(String)
    case errorParsingFailed
    case olderAppVersion
    case refreshingFailed
    case internalError(String)
    case multipleErrors([NetworkingErrorModel.ErrorInfo])
    case needExtraLogin
    case backgroundRequestError
}

public struct DataFetchResult {
    let route: Routing
    let data: Data
    let response: URLResponse?
}
