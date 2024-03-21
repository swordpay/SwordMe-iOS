//
//  ViewControllerProvider+MultiActionedInfo.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 08.12.22.
//

import Swinject
import Foundation

extension ViewControllerProvider {
    enum MultiActionedInfo {
        static var notificationPermission: NotificationAccessViewController {
            let assembler = Assembler([NotificationAccessViewControllerAssembly()])

            return assembler.resolver.resolve(NotificationAccessViewController.self)!
        }
    }
}
