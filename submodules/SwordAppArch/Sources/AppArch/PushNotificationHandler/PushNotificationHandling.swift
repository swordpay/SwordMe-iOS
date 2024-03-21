//
//  PushNotificationHandling.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 24.02.23.
//

import Foundation

protocol PushNotificationHandling {
    var needAuthorization: Bool { get }
    var userInfo: [AnyHashable: Any]? { get }
    
    init(userInfo: [AnyHashable: Any]?)
    
    func handle()
}
