//
//  DataFetchMockValidator.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 29.06.22.
//

import Combine
import Swinject
import Foundation

public final class DataFetchMockValidator: DataFetchValidating {
    public func validate(result: DataFetchResult) -> AnyPublisher<Data, Error> {
        return Just(result.data)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
    }
}

public final class DataFetchMockValidatorAssembly: Assembly {
    public func assemble(container: Container) {
        container.register(DataFetchValidating.self) { _ in
            return DataFetchMockValidator()
        }
    }
}
