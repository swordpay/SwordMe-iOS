//
//  NotificationManaging.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 17.05.22.
//

import Foundation
import Combine

protocol NotificationManaging {
    var authorizationStatusPublisher: CurrentValueSubject<NotificationAuthorizationStatus?, Never> { get }

    func checkAuthorizationStatus()
    func registerForPushNotifications()
    func handlePushNotifications(userInfo: [AnyHashable: Any]?)
}
