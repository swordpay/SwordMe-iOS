//
//  DataCacher.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 13.04.22.
//

import Foundation

public final class DataCacher: DataCaching {
    private var _cache: [URL: Data] = [:]
    private var queue = DispatchQueue(label: "Constants.AppLabel.cacherIdentifier", attributes: .concurrent)

    public var cache: [URL: Data] {
        queue.sync {
            return _cache
        }
    }

    public func add(_ data: Data, for url: URL) {
        queue.async(flags: .barrier) { [ weak self ] in
            self?._cache[url] = data
        }
    }

    public func removeData(for url: URL) {
        queue.async(flags: .barrier) { [ weak self ] in
            self?._cache.removeValue(forKey: url)
        }
    }
}
