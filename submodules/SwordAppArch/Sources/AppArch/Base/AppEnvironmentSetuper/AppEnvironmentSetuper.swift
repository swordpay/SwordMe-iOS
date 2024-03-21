//
//  AppEnvironmentSetuper.swift
//  SwordAppArch
//
//  Created by Tigran Simonyan on 01.10.23.
//

import Foundation

public final class AppEnvironmentSetuper {
    public static let global: AppEnvironmentSetuper = {
        struct SingletonWrapper {
            static let singleton = AppEnvironmentSetuper()
        }

        return SingletonWrapper.singleton
    }()

    private init() {

    }

    public func setupEnvironment () {
        AppEnvironment.configure(.production)
    }
}
