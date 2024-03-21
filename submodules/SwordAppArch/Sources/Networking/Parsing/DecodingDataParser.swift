//
//  DecodingDataParser.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 12.04.22.
//

import Combine
import Foundation

public final class DecodingDataParser: DataParsing {
    public func parse<T>(data: Data) -> AnyPublisher<T, Error> where T: Decodable {
        return Future { promise in
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                promise(.success(decoded))
            } catch {
                print("Decoding failed \(error)")
                promise(.failure(DataParsingError.decodingFailed(error)))
            }
        }.eraseToAnyPublisher()
    }
}
