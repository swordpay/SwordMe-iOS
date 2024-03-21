//
//  CardExpirationDateValidator.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 20.12.22.
//

import Foundation

final class CardExpirationDateValidator: TextValidating {
    func validate(_ text: String?) -> Constants.Typealias.TextValidationResult {
        guard let text = text, !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return (.failure(Constants.Localization.ValidationMessage.requiredField), text)
        }

        let range = NSRange(location: 0, length: text.utf16.count)
        let regex = try! NSRegularExpression(pattern: " / ")
        
        guard regex.firstMatch(in: text, options: [], range: range) != nil,
              text.count == 7,
              validateDate(text) else {
            return (.failure(Constants.Localization.ValidationMessage.invalidCardExpirationDate), text)
        }
        
        return (.success, text.trimmingCharacters(in: .whitespacesAndNewlines))
    }
    
    private func validateDate(_ date: String) -> Bool {
        let dateComponents = date.components(separatedBy: " / ")
        guard let expirationDate = prepareDate(components: dateComponents) else { return false }

        var maxDateComponent = DateComponents()
        maxDateComponent.year = 3
        
        var minDateComponent = DateComponents()
        minDateComponent.month = 1
        
        let componetns: Set<Calendar.Component> = [.year, .month]
    
        if let threeYearLater = Calendar.current.date(byAdding: maxDateComponent, to: Date()),
           let oneMonthLater = Calendar.current.date(byAdding: minDateComponent, to: Date()) {
            return expirationDate.keepComponents(componetns) >= oneMonthLater.keepComponents(componetns)
                    && expirationDate.keepComponents(componetns) <= threeYearLater.keepComponents(componetns)
        } else {
            return expirationDate.keepComponents(componetns) >= Date().keepComponents(componetns)
        }
    }
    
    private func prepareDate(components: [String]) -> Date? {
        let calendar = Calendar(identifier: .gregorian)

        guard let month = Int(components[0]),
              let year = Int(components[1]),
              let day = calendar.dateComponents([.day], from: Date()).day,
              (1...12).contains(month) else { return nil }
        
        let fullYear = year + 2000
        let components = DateComponents(year: fullYear, month: month, day: day)
        
        return calendar.date(from: components)
    }
}
