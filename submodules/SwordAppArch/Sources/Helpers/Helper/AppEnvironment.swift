//
//  AppEnvironment.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 20.07.22.
//

import Foundation

enum AppEnvironment {
    case production
    case staging
    case mock

    static var current: AppEnvironment = .production
    static var isStaging: Bool {
        return current == .staging
    }

    static func configure(_ environment: AppEnvironment) {
        self.current = environment
//        #if PROD
//        current = .production
//        #elseif STG
//        current = .staging
//        #elseif MOCK
//        current = .mock
//        #else
//        fatalError()
//        #endif
    }
}
