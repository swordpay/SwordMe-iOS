//
//  DataDownloading.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 13.04.22.
//

import Foundation
import Combine

public enum DataDownloadError: Error {
    case invalidPath(String)
    case general(Error)
}

public protocol DataDownloading {
    func download(from url: URL) -> AnyPublisher<Data, Error>
    func cancelDownloading(for url: URL)
}
