//
//  DataFetchValidating.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 29.06.22.
//

import Combine
import Foundation

public protocol DataFetchValidating {
    func validate(result: DataFetchResult) -> AnyPublisher<Data, Error>
}
