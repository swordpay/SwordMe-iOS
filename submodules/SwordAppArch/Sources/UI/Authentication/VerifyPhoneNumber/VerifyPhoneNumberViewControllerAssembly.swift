//
//  VerifyPhoneNumberViewControllerAssembly.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 07.12.22.
//

import Swinject
import Foundation

final class VerifyPhoneNumberViewControllerAssembly: Assembly {
    let phoneNumber: String
    let isLoginInfoNeeded: Bool
    let verificationReason: PhoneNumberVerificationReason
    let destination: VerifyPhoneNumberDestination
    let loginWithCode: ((String) -> Void)?
    let requestNextOption: (() -> Void)?
    let back: (() -> Void)?
    
    init(phoneNumber: String,
         isLoginInfoNeeded: Bool,
         verificationReason: PhoneNumberVerificationReason,
         destination: VerifyPhoneNumberDestination,
         loginWithCode: ((String) -> Void)?,
         requestNextOption: (() -> Void)?,
         back: (() -> Void)?) {
        self.phoneNumber = phoneNumber
        self.isLoginInfoNeeded = isLoginInfoNeeded
        self.verificationReason = verificationReason
        self.destination = destination
        self.loginWithCode = loginWithCode
        self.requestNextOption = requestNextOption
        self.back = back
    }

    func assemble(container: Container) {
        let phoneNumber = phoneNumber
        let isLoginInfoNeeded = isLoginInfoNeeded
        let verificationReason = verificationReason
        let destination = destination
        let loginWithCode = loginWithCode
        let requestNextOption = requestNextOption
        let back = back

        container.register(VerifyPhoneNumberViewModel.self) { resolver in
            let verifyPhoneNumberService = resolver.resolve(VerifyPhoneNumberServicing.self)!
            let phoneNumberService = resolver.resolve(PhoneNumberServicing.self)!
            let resendVerificationCodeService = resolver.resolve(ResendVerificationCodeServicing.self)!
            let inputs = VerifyPhoneNumberViewModelInputs(verifyPhoneNumberService: verifyPhoneNumberService,
                                                          phoneNumberService: phoneNumberService,
                                                          resendVerificationCodeService: resendVerificationCodeService)
            return VerifyPhoneNumberViewModel(inputs: inputs,
                                              phoneNumber: phoneNumber,
                                              isLoginInfoNeeded: isLoginInfoNeeded,
                                              verificationReason: verificationReason,
                                              destination: destination,
                                              loginWithCode: loginWithCode,
                                              requestNextOption: requestNextOption,
                                              back: back)
        }

        container.register(VerifyPhoneNumberViewController.self) { resolver in
            let viewModel = resolver.resolve(VerifyPhoneNumberViewModel.self)!
            let viewController = VerifyPhoneNumberViewController(viewModel: viewModel)
            
            return viewController
        }
    }
}
