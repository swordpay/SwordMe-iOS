//
//  InternetManagerAssembly.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 17.05.22.
//

import Foundation
import Swinject

final class InternetManagerAssembly: Assembly {
    func assemble(container: Container) {
        container.register(InternetManaging.self) { _ in
            return InternetManager()
        }
    }
}
