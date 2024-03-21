//
//  RequiredFieldValidator.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 15.09.22.
//

import Foundation

final class RequiredFieldValidator: TextValidating {
    let minLenght: Int
    let maxLenght: Int?
    
    init(minLenght: Int = 0, maxLenght: Int? = nil) {
        self.minLenght = minLenght
        self.maxLenght = maxLenght
    }
    
    func validate(_ text: String?) -> Constants.Typealias.TextValidationResult {
        guard let text = text, !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return (.failure(""), text)
        }

        let textLenght = text.trimmingCharacters(in: .whitespacesAndNewlines).count

        guard let maxLenght else {
            if textLenght >= minLenght {
                return (.success, text.trimmingCharacters(in: .whitespacesAndNewlines))
            } else {
                return (.failure("Text should have minimum \(minLenght) symbols"), text)
            }
        }

        if (minLenght...maxLenght).contains(textLenght) {
            return (.success, text.trimmingCharacters(in: .whitespacesAndNewlines))
        } else {
            return (.failure(Constants.Localization.ValidationMessage.requiredFieldRange(minLenght: minLenght, maxLenght: maxLenght)), text)
        }
    }
}
