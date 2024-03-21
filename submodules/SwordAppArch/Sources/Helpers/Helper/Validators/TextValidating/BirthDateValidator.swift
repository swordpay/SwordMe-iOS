//
//  BirthDateValidator.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 20.01.23.
//

import Foundation

final class BirthDateValidator: TextValidating {
    func validate(_ text: String?) -> Constants.Typealias.TextValidationResult {
        
        guard let text,
              text.count == 10,
              let date = text.toDate(with: Constants.DateFormat.MMddYYYY_slashed),
              let eightteenYearsAgo = Calendar.current.date(byAdding: .year, value: -18, to: Date()),
              let maxAge = Calendar.current.date(byAdding: .year, value: -100, to: Date()) else {
            return (.failure(Constants.Localization.ValidationMessage.birthDateInvalidDate), text)
        }

        guard date.removeTimeStamp < Date().removeTimeStamp else {
            return (.failure("You have to be born))"), text)
        }

        if date.removeTimeStamp < maxAge.removeTimeStamp {
            return (.failure(Constants.Localization.ValidationMessage.birthDateInvalidDate), text)
        } else if date.removeTimeStamp > eightteenYearsAgo.removeTimeStamp {
            return (.failure(Constants.Localization.ValidationMessage.birthDateNotAnAdult), text)
        } else {
            return (.success, text.trimmingCharacters(in: .whitespacesAndNewlines))
        }
    }
}

