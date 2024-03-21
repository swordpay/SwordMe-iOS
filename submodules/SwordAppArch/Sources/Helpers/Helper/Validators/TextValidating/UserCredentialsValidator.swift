//
//  UserCredentialsValidator.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 23.01.23.
//

import Foundation

final class UserCredentialsValidator: TextValidating {
    private let emailValidator = EmailValidator()
    private let phoneNumberValidator = PhoneNumberValidator()
    
    func validate(_ text: String?) -> Constants.Typealias.TextValidationResult {
        guard let text else { return (.failure(Constants.Localization.ValidationMessage.requiredField),
                                      text?.trimmingCharacters(in: .whitespacesAndNewlines)) }
        let phoneNumberValidationResult = phoneNumberValidator.validate(text)
        let isValidEmail = emailValidator.validate(text).0 == .success
        let isValidPhoneNumber = phoneNumberValidationResult.0 == .success
        
        if isValidEmail || isValidPhoneNumber {
            let text = isValidPhoneNumber ? phoneNumberValidationResult.1 : text

            return (.success, text?.trimmingCharacters(in: .whitespacesAndNewlines))
        } else {
            return (.failure(Constants.Localization.ValidationMessage.invalidCredential), text.trimmingCharacters(in: .whitespacesAndNewlines))
        }
    }
}
