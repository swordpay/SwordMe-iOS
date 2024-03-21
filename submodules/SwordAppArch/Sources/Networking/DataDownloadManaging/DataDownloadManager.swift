//
//  DataDownloadManager.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 13.04.22.
//

import Foundation
import Combine

public final class DataDownloadManager: DataDownloadManaging {
    public var downloader: DataDownloading
    public var cacher: DataCaching

    public init(downloader: DataDownloading, cacher: DataCaching) {
        self.downloader = downloader
        self.cacher = cacher
    }

    public func download(from url: URL) -> AnyPublisher<Data, Error> {
        if let data = cacher.cache[url] {
            return Just(data).setFailureType(to: Error.self).eraseToAnyPublisher()
        }

        return downloader.download(from: url)
            .flatMap({ [ weak self ] data -> Just<Data> in
                self?.cacher.add(data, for: url)

                return Just.init(data)
            })
            .eraseToAnyPublisher()
    }

    public func cancelDownloading(for url: URL) {
        downloader.cancelDownloading(for: url)
    }
}
