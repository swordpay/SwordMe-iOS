//
//  CameraManagerAssembly.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 17.05.22.
//

import Swinject
import Foundation

final class CameraManagerAssembly: Assembly {
    func assemble(container: Container) {
        container.register(CameraManaging.self) { _ in
            return CameraManager()
        }
    }
}
