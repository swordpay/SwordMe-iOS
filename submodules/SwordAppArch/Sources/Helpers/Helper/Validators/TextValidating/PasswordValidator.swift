//
//  PasswordValidator.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 22.06.22.
//

import Combine
import Foundation

struct PasswordValidator: TextValidating {
    func validate(_ text: String?) -> Constants.Typealias.TextValidationResult {
        guard let password = text,
              !password.trimmingCharacters(in: .whitespaces).isEmpty else {
            return (.failure(Constants.Localization.ValidationMessage.emptyPassword), nil)
        }

        let passwordWithoutWhitespaces = password.trimmingCharacters(in: .whitespaces)

        guard passwordWithoutWhitespaces.count >= 0 && passwordWithoutWhitespaces.count <= 50 else {
            return (.failure(Constants.Localization.ValidationMessage.invalidPasswordLenght), nil)
        }

        if isPasswordValid(passwordWithoutWhitespaces) {
            return (.success, passwordWithoutWhitespaces)
        } else {
            return (.failure(Constants.Localization.ValidationMessage.invalidPassword), passwordWithoutWhitespaces)
        }
    }
    
    private func isPasswordValid(_ password: String) -> Bool {
        let passwordRegEx = "^(?=.*\\p{Ll})(?=.*\\p{Lu})(?=.*\\p{N})(?=.*[\\p{P}\\p{S}\\p{Sc}]).{8,}$"
        let passwordPredicate = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        
        return passwordPredicate.evaluate(with: password)
    }

    private func isPasswordMatchingOptions(_ password: String) -> Bool {
        guard password.count >= 8 else { return false }

        let isPasswordContainsUppercase = password.rangeOfCharacter(from: CharacterSet.uppercaseLetters) != nil
        let isPasswordContainsLowercase = password.rangeOfCharacter(from: CharacterSet.lowercaseLetters) != nil
        let isPasswordContainsNumber = password.rangeOfCharacter(from: CharacterSet(charactersIn: "0123456789")) != nil
        let isPasswordContainsSymbol = password.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) != nil
        
        return isPasswordContainsUppercase && isPasswordContainsLowercase && isPasswordContainsNumber && isPasswordContainsSymbol
    }
}

final class RepeatPasswordValidator: TextValidating {
    private var cancellables: Set<AnyCancellable> = []

    var originalPassword: String?
    
    init(originalPassword: String? = nil) {
        self.originalPassword = originalPassword
    }
    
    func validate(_ text: String?) -> Constants.Typealias.TextValidationResult {
        guard let password = text,
              !password.trimmingCharacters(in: .whitespaces).isEmpty else { return (.failure(Constants.Localization.ValidationMessage.emptyPassword), nil) }

        let passwordWithoutWhiteSpaces = password.trimmingCharacters(in: .whitespaces)

        return isMatchingWithOriginalPassword(passwordWithoutWhiteSpaces)
    }

    private func isMatchingWithOriginalPassword(_ currentPassword: String) -> Constants.Typealias.TextValidationResult {
        guard let originalPassword = originalPassword, !originalPassword.isEmpty else {
            return (.failure(Constants.Localization.ValidationMessage.mainPasswordIsEmpty), currentPassword)
        }

        guard originalPassword == currentPassword else {
            return (.failure(Constants.Localization.ValidationMessage.passwordsAreDifferent), currentPassword)
        }
        
        return (.success, currentPassword)
    }
}
