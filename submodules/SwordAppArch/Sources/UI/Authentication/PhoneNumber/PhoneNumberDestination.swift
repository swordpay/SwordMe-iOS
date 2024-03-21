//
//  PhoneNumberDestination.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 07.12.22.
//

import UIKit

public enum PhoneNumberDestination: Destinationing {
    case verifyCode(String,
                    verificationReason: PhoneNumberVerificationReason,
                    destination: VerifyPhoneNumberDestination)
    
    public var viewController: UIViewController {
        switch self {
        case .verifyCode(let phoneNumber,
                         let verificationReason,
                         let destination):
            return ViewControllerProvider.Authentication.verifyPhoneNumber(with: phoneNumber,
                                                                           isLoginInfoNeeded: true,
                                                                           verificationReason: verificationReason,
                                                                           destination: destination,
                                                                           loginWithCode: nil,
                                                                           requestNextOption: nil,
                                                                           back: nil)
        }
    }

    public var navigationType: NavigationType {
        return .push(animated: true)
    }
}
