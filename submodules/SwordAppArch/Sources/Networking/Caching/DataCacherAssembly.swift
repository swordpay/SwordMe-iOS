//
//  DataCacherAssembly.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 11.05.22.
//

import Foundation
import Swinject

public final class DataCacherAssembly: Assembly {
    public func assemble(container: Container) {
        container.register(DataCaching.self) { _ in
            return DataCacher()
        }
    }
}
