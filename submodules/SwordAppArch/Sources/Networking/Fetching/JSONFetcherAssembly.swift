//
//  JSONFetcherAssembly.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 12.04.22.
//

import Foundation
import Swinject

final class JSONFetcherAssembly: Assembly {
    func assemble(container: Container) {
        container.register(DataFetching.self) { _ in
            return JSONFetcher()
        }
    }
}
