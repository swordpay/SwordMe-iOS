//
//  SystemServiceType.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 30.05.22.
//

import Foundation

struct SystemServiceType: OptionSet, Hashable {
    let rawValue: Int

    static let location = SystemServiceType(rawValue: 1 << 0)
    static let notification = SystemServiceType(rawValue: 1 << 1)
    static let internet = SystemServiceType(rawValue: 1 << 2)
    static let all: SystemServiceType = [.location, .notification, .internet]
}
