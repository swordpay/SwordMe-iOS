//
//  URLSessionFetcherAssembly.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 12.04.22.
//

import Swinject
import Foundation

public final class URLSessionFetcherAssembly: Assembly {
    let config: URLSessionConfiguration

    public init(config: URLSessionConfiguration = .default) {
        self.config = config
    }

    public func assemble(container: Container) {
        let config = config

        container.register(DataFetching.self) { _ in
            return URLSessionFetcher(config: config)
        }
    }
}
