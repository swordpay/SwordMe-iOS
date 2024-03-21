//
//  TextCountValidator.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 16.12.22.
//

import Foundation

final class TextCountValidator: TextValidating {
    let count: Int
    
    init(count: Int) {
        self.count = count
    }

    func validate(_ text: String?) -> Constants.Typealias.TextValidationResult {
        guard let text = text, !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return (.failure(Constants.Localization.ValidationMessage.requiredField), text)
        }

        if text.count == count {
            return (.success, text.trimmingCharacters(in: .whitespacesAndNewlines))
        } else {
            return (.failure(Constants.Localization.ValidationMessage.invalidTextLenght), text)
        }
    }
}
