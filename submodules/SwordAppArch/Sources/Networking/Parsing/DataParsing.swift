//
//  DataParsing.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 12.04.22.
//

import Foundation
import Combine

public enum DataParsingError: Error {
    case decodingFailed(Error)
}

public protocol DataParsing {
    func parse<T: Decodable>(data: Data) -> AnyPublisher<T, Error>
}
