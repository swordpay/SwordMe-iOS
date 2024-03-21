//
//  CardHolderNameValidator.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 16.12.22.
//

import Foundation

struct CardHolderNameValidator: TextValidating {
    func validate(_ text: String?) -> Constants.Typealias.TextValidationResult {
        
        guard let nameOnCard = text,
              !nameOnCard.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return (.failure(Constants.Localization.ValidationMessage.emptyCardHolderName), nil)
        }

        
        let nameOnCardWithoutWhiteSpaces = nameOnCard.trimmingCharacters(in: .whitespacesAndNewlines)
        if let _ = nameOnCardWithoutWhiteSpaces.first (where: {
            return !$0.isLowercase && !$0.isUppercase && !$0.isWhitespace
        }) {
            return (.failure(Constants.Localization.ValidationMessage.invalidCardHolderName), nameOnCardWithoutWhiteSpaces)
        } else {
            return (.success, nameOnCardWithoutWhiteSpaces)
        }
    }
}
