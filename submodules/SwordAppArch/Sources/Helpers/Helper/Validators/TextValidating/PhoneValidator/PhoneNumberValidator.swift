//
//  PhoneNumberValidator.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 01.06.22.
//

import Foundation
import PhoneNumberFormat

class PhoneNumberValidator: TextValidating {
    func validate(_ text: String?) -> Constants.Typealias.TextValidationResult {
        guard let phoneNumber = text,
              !phoneNumber.trimmingCharacters(in: .whitespaces).isEmpty else {
            return (.failure(""), nil)
        }
        
        let phoneNumberWithoutWhitespaces = phoneNumber.trimmingCharacters(in: .whitespaces)

        guard isViablePhoneNumber(phoneNumberWithoutWhitespaces) else {
            return (.failure(Constants.Localization.ValidationMessage.invalidPhoneNumber), phoneNumberWithoutWhitespaces)
        }
        
        return (.success, phoneNumber)
    }
}
