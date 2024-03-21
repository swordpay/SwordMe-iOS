//
//  URLSessionDataDownloaderAssembly.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 13.04.22.
//

import Foundation
import Swinject

public final class URLSessionDataDownloaderAssembly: Assembly {
    public func assemble(container: Container) {
        container.register(DataDownloading.self) { _ in
            return URLSessionDataDownloader()
        }
    }
}
