//
//  NotificationManagerProvider.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 17.05.22.
//

import Foundation
import Swinject

enum NotificationManagerProvider {
    static var native: NotificationManaging = {
        let assembler = Assembler([NotificationManagerAssembly()])

        return assembler.resolver.resolve(NotificationManaging.self)!
    }()
}
