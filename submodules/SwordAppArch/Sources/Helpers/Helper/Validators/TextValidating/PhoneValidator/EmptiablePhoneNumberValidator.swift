//
//  EmptiablePhoneNumberValidator.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 01.06.22.
//

import Foundation

final class EmptiablePhoneNumberValidator: PhoneNumberValidator {
    override func validate(_ text: String?) -> Constants.Typealias.TextValidationResult {
        guard let text = text, !text.trimmingCharacters(in: .whitespaces).isEmpty else {
            return (.success, nil)
        }

        return super.validate(text)
    }
}
