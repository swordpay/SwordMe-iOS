//
//  DataCaching.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 13.04.22.
//

import Foundation

public protocol DataCaching {
    var cache: [URL: Data] { get }

    func add(_ data: Data, for url: URL)
    func removeData(for url: URL)
}
