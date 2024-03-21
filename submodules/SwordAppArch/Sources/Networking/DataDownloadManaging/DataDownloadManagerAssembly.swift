//
//  DataDownloadManagerAssembly.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 13.04.22.
//

import Foundation
import Swinject

public final class DataDownloadManagerAssembly: Assembly {
    public func assemble(container: Container) {
        container.register(DataDownloadManaging.self) { resolver in
            let downloader = resolver.resolve(DataDownloading.self)!
            let cacher = resolver.resolve(DataCaching.self)!

            return DataDownloadManager(downloader: downloader, cacher: cacher)
        }
    }
}
