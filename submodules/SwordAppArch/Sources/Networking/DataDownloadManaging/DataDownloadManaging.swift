//
//  DataDownloadManaging.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 13.04.22.
//

import Foundation
import Combine

public protocol DataDownloadManaging {
    var downloader: DataDownloading { get }
    var cacher: DataCaching { get }

    init(downloader: DataDownloading, cacher: DataCaching)

    func download(from url: URL) -> AnyPublisher<Data, Error>
    func cancelDownloading(for url: URL)
}
