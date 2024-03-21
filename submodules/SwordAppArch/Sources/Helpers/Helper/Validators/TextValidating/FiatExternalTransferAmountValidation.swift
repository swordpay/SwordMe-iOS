//
//  FiatExternalTransferAmountValidation.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 04.04.23.
//

import Foundation

final class FiatExternalTransferAmountValidation: TextValidating {
    let minAmount: Double
    let maxAmount: Double
    
    init(minAmount: Double, maxAmount: Double) {
        self.minAmount = minAmount
        self.maxAmount = maxAmount
    }
    
    func validate(_ text: String?) -> Constants.Typealias.TextValidationResult {
        guard let text = text, !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return (.failure(""), text)
        }
        
        let textWithoutWhitspaces = text.trimmingCharacters(in: .whitespaces)

         
        guard let amount = textWithoutWhitspaces.formattedDecimalNumber(maximumFractionDigits: Constants.fiatDefaultPrecision) else {
            return (.failure(Constants.Localization.ValidationMessage.externalTransferInvalidAmount), text)
        }
        
        guard amount >= minAmount else {
            return (.failure("Minimum allowed value is 1 €"), text)
        }
        
        guard amount <= maxAmount else {
            return (.failure("Balance exceeded"), text)
        }
        

        return (.success, textWithoutWhitspaces)
    }
}
