//
//  LocationSnapshotProviding.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 25.07.22.
//

import Swinject
import Foundation

final class LocationSnapshotProviderAssembly: Assembly {
    func assemble(container: Container) {
        container.register(LocationSnapshotProviding.self) { _ in
            return LocationSnapshotProvider()
        }
    }
}
