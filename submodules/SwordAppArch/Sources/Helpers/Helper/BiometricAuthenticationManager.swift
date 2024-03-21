//
//  BiometricAuthenticationManager.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 15.08.22.
//

import UIKit
import Combine
import LocalAuthentication

protocol BiometricAuthenticationManager: AnyObject {
    var context: LAContext { get set }
    var error: PassthroughSubject<Error?, Never> { get set }

    func askBiometricAuthenticationPermission() -> Bool
    func performBiometricAuthentication(policy: LAPolicy, completion: @escaping Constants.Typealias.CompletioHandler<Bool>)
}

extension BiometricAuthenticationManager {
    func askBiometricAuthenticationPermission() -> Bool {
        var error: NSError?
        let canEvaluate = context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error)

        if canEvaluate {
            return true
        } else {
            self.error.send(BiometricAuthenticationError.evaluationFail)
            return false
        }
    }
    
    func performBiometricAuthentication(policy: LAPolicy, completion: @escaping Constants.Typealias.CompletioHandler<Bool>) {
        context.evaluatePolicy(
            .deviceOwnerAuthentication,
            localizedReason: Constants.Localization.Profile.biometricAuthenticationReason
        ) { [ weak self ] success, error in
            DispatchQueue.main.async {
                if success {
                    completion(true)
                } else {
                    guard let error = error as? LAError else {
                        self?.error.send(BiometricAuthenticationError.authenticationFailed(false))
                        completion(false)

                        return
                    }

                    var isCanceled = false

                    if error.code == .userCancel {
                        isCanceled = true
                    }

                    self?.error.send(BiometricAuthenticationError.authenticationFailed(isCanceled))
                    completion(false)
                }
            }
        }
    }
}
