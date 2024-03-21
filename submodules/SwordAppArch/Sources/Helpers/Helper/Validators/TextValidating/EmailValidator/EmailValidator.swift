//
//  EmailValidator.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 25.05.22.
//

import Foundation

struct EmailValidator: TextValidating {
    func validate(_ text: String?) -> Constants.Typealias.TextValidationResult {
        guard let email = text,
              !email.trimmingCharacters(in: .whitespaces).isEmpty else { return (.failure(""), nil) }

        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let emailWithoutWhitespaces = email.trimmingCharacters(in: .whitespaces)
        
        guard emailPredicate.evaluate(with: emailWithoutWhitespaces) else {
            return (.failure(Constants.Localization.ValidationMessage.invalidEmail), emailWithoutWhitespaces)
        }

        return (.success, emailWithoutWhitespaces)
    }
}
