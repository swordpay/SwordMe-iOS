//
//  PushNotificationBaseHandler.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 24.02.23.
//

import UIKit
import Combine
import LocalAuthentication

class PushNotificationBaseHandler: PushNotificationHandling, BiometricAuthenticationManager {
    var error: PassthroughSubject<Error?, Never> = PassthroughSubject()
    var context: LAContext = LAContext()
    
    var needAuthorization: Bool {
        fatalError("This method must be implemented in childer")
    }
    
    let userInfo: [AnyHashable : Any]?
    
    required init(userInfo: [AnyHashable : Any]?) {
        self.userInfo = userInfo
    }

    func handle() {
        goToScreen()
    }

    func goToScreen() {
        fatalError("This method must be implemented in childer")
    }
}
