//
//  ViewControllerProvider+Authentication.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 05.12.22.
//

import UIKit
import Combine
import Swinject
import TelegramCore
import LegacyComponents

public extension ViewControllerProvider {
    enum Authentication {
        public static func phoneNumber(verificationReason: PhoneNumberVerificationReason,
                                       otherAccountPhoneNumbers: ((String, AccountRecordId, Bool)?, [(String, AccountRecordId, Bool)]),
                                       loginWithNumber: ((String, Bool) -> Void)? ) -> PhoneNumberViewController {
            let assembler = Assembler([ PhoneNumberServiceAssembly(),
                                        PhoneNumberViewControllerAssembly(verificationReason: verificationReason, 
                                                                          otherAccountPhoneNumbers: otherAccountPhoneNumbers, loginWithNumber: loginWithNumber)])

            return assembler.resolver.resolve(PhoneNumberViewController.self)!

        }
        
        public static func verifyPhoneNumber(with phoneNumber: String,
                                             isLoginInfoNeeded: Bool,
                                             verificationReason: PhoneNumberVerificationReason,
                                             destination: VerifyPhoneNumberDestination,
                                             loginWithCode: ((String) -> Void)?,
                                             requestNextOption: (() -> Void)?,
                                             back: (() -> Void)?) -> VerifyPhoneNumberViewController {
            
            let assembler = Assembler([ PhoneNumberServiceAssembly(),
                                        VerifyPhoneNumberServiceAssembly(),
                                        ResendVerificationCodeServiceAssembly(),
                                        VerifyPhoneNumberViewControllerAssembly(phoneNumber: phoneNumber,
                                                                                isLoginInfoNeeded: isLoginInfoNeeded,
                                                                                verificationReason: verificationReason,
                                                                                destination: destination,
                                                                                loginWithCode: loginWithCode,
                                                                                requestNextOption: requestNextOption,
                                                                                back: back)])
            
            return assembler.resolver.resolve(VerifyPhoneNumberViewController.self)!
        }
        
        
        static var forgotPassword: ForgotPasswordViewController {
            let assembler = Assembler([ ForgotPasswordServiceAssembly(),
                                        ForgotPasswordViewControllerAssembly() ])
            
            return assembler.resolver.resolve(ForgotPasswordViewController.self)!
        }
        
        public static var resetPassword: ResetPasswordViewController {
            let assembler = Assembler([ ResetPasswordServiceAssembly(),
                                        ResetPasswordViewControllerAssembly() ])
            
            return assembler.resolver.resolve(ResetPasswordViewController.self)!
        }
                
        public static func tfaPassword(passwordHint: String, state: TFAPasswordStackViewModel.State) -> TFAPasswordViewController {
            let assembler = Assembler([ TFAPasswordViewControllerAssembly(passwordHint: passwordHint, state: state) ])
            
            return assembler.resolver.resolve(TFAPasswordViewController.self)!
        }
        
        public static func emailRecovery(email: String) -> EmailRecoveryViewController {
            let assembler = Assembler([ EmailRecoveryViewControllerAssembly(email: email) ])
            
            return assembler.resolver.resolve(EmailRecoveryViewController.self)!
        }
    }
}
