//
//  DataFetchManagerAssembly.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 13.04.22.
//

import Swinject
import Foundation

public final class DataFetchManagerAssembly: Assembly {
    public func assemble(container: Container) {
        container.register(DataFetchManaging.self) { resolver in
            let fetcher = resolver.resolve(DataFetching.self)!
            let validator = resolver.resolve(DataFetchValidating.self)!
            let parser = resolver.resolve(DataParsing.self)!

            return DataFetchManager(fetcher: fetcher, validator: validator, parser: parser)
        }
    }
}
