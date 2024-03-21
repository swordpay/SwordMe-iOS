//
//  BiometricAuthenticationError.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 05.12.22.
//

import Foundation
import LocalAuthentication

enum BiometricAuthenticationError: Error {
    case evaluationFail
    case authenticationFailed(Bool)
}
