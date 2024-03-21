//
//  JSONFetcher.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 12.04.22.
//

import Foundation
import Combine

public final class JSONFetcher: DataFetching {
    public func fetch(from route: Routing) -> AnyPublisher<DataFetchResult, Error> {
        return Future<DataFetchResult, Error> { promise in
            let fileName = route.key.fileName

            guard let path = Constants.mainBundle.path(forResource: fileName, ofType: Constants.FileType.json.rawValue) else {
                promise(.failure(DataFetchingError.missingJSON(fileName)))

                return
            }

            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let result = DataFetchResult(route: route, data: data, response: nil)

                promise(.success(result))
            } catch {
                promise(.failure(DataFetchingError.inaccessibleData(fileName, error)))
            }
        }.eraseToAnyPublisher()
    }
}
