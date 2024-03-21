//
//  PhoneNumberViewControllerAssembly.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 07.12.22.
//

import Swinject
import Foundation
import TelegramCore

final class PhoneNumberViewControllerAssembly: Assembly {
    let verificationReason: PhoneNumberVerificationReason
    let otherAccountPhoneNumbers: ((String, AccountRecordId, Bool)?, [(String, AccountRecordId, Bool)])
    let loginWithNumber: ((String, Bool) -> Void)?
    
    init(verificationReason: PhoneNumberVerificationReason,
         otherAccountPhoneNumbers: ((String, AccountRecordId, Bool)?, [(String, AccountRecordId, Bool)]),
         loginWithNumber: ((String, Bool) -> Void)?) {
        self.verificationReason = verificationReason
        self.otherAccountPhoneNumbers = otherAccountPhoneNumbers
        self.loginWithNumber = loginWithNumber
    }

    func assemble(container: Container) {
        let verificationReason = self.verificationReason
        let otherAccountPhoneNumbers = self.otherAccountPhoneNumbers
        let loginWithNumber = self.loginWithNumber

        container.register(PhoneNumberViewModel.self) { resolver in
            let phoneNumberService = resolver.resolve(PhoneNumberServicing.self)!
            let inputs = PhoneNumberViewModelInputs(phoneNumberService: phoneNumberService)
            let viewModel = PhoneNumberViewModel(inputs: inputs,
                                                 verificationReason: verificationReason,
                                                 otherAccountPhoneNumbers: otherAccountPhoneNumbers,
                                                 loginWithNumber: loginWithNumber)

            return viewModel
        }
     
        container.register(PhoneNumberViewController.self) { resolver in
            let viewModel = resolver.resolve(PhoneNumberViewModel.self)!
            let viewController = PhoneNumberViewController(viewModel: viewModel)
            
            return viewController
        }
    }
}
