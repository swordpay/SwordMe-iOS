//
//  NotificationManagerAssembly.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 17.05.22.
//

import Foundation
import Swinject

final class NotificationManagerAssembly: Assembly {
    func assemble(container: Container) {
        container.register(NotificationManaging.self) { _ in
            return NotificationManager()
        }
    }
}
