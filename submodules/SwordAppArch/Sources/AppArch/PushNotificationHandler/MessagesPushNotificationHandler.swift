//
//  MessagesPushNotificationHandler.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 27.04.23.
//

import UIKit
import Combine

final class MessagesPushNotificationHandler: PushNotificationBaseHandler {
    override var needAuthorization: Bool { return true }
    
    override func goToScreen() {
        let viewController = UIViewController()
        let navController = BaseNavigationController(rootViewController: viewController)
                
        UIApplication.shared.topMostViewController()?.present(navController, animated: true)
    }
}
