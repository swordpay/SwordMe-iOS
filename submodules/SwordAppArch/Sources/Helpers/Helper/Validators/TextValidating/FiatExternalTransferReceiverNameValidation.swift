//
//  FiatExternalTransferReceiverNameValidation.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 04.04.23.
//

import Foundation

final class FiatExternalTransferReceiverNameValidation: TextValidating {
    func validate(_ text: String?) -> Constants.Typealias.TextValidationResult {
        guard let text = text, !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return (.failure(Constants.Localization.ValidationMessage.requiredField), text)
        }
        
        guard text.count <= 35 else {
            return (.failure(Constants.Localization.ValidationMessage.externalTransferReceiverNameLenght), text)
        }

        let textWithoutWhitspaces = text.trimmingCharacters(in: .whitespaces)
        let withdrawAddressPredicate = NSPredicate(format:"SELF MATCHES %@", "^[a-zA-Z0-9\\s\\?:\\(\\)\\.,\\+\\-]{1,35}$")

        guard withdrawAddressPredicate.evaluate(with: textWithoutWhitspaces) else {
            return (.failure(Constants.Localization.ValidationMessage.externalTransferReceiverNameInvalidSymbols),
                    textWithoutWhitspaces)
        }

        return (.success, textWithoutWhitspaces)
    }
}
