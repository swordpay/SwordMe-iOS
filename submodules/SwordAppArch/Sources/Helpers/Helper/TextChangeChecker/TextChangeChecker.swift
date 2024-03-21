//
//  TextChangeChecker.swift
//  SwordAppArch
//
//  Created by Tigran Simonyan on 19.01.24.
//

import UIKit

public protocol TextChangeChecking {
    func canChange(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
}


public final class TextChangeChecker: TextChangeChecking {
    var mainPartMaxLenght: Int
    var precision: Int
    
    public init(precision: Int, mainPartMaxLenght: Int = Constants.maximumDigitsOfDouble) {
        self.precision = precision
        self.mainPartMaxLenght = mainPartMaxLenght
    }
    public func canChange(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var updatedString = string.replacingOccurrences(of: "[^\\d.,]+", with: "", options: .regularExpression)

        if updatedString.count > 1 {
            updatedString = updatedString.replacingOccurrences(of: ",", with: "")
        }

        updatedString = updatedString.replacingOccurrences(of: ",", with: ".")
        
        if (textField.text ?? "").contains(".") && updatedString == "." {
            return false
        }
        
        let currentString = (textField.text ?? "") as NSString
        let newString = currentString.replacingCharacters(in: range, with: updatedString).replacingOccurrences(of: ",", with: "")
        
        guard !newString.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return true }

        if precision == 0 && newString.contains(".") {
            return false
        }

//        guard let fotmattedNewString = newString
//            .formattedDecimalNumber(usesGroupingSeparator: false, maximumFractionDigits: precision)?
//            .bringToPresentableFormat(usesGroupingSeparator: false, maximumFractionDigits: precision) else { return false }

        let components = newString.components(separatedBy: ".")

        guard components.count <= 2 else { return false }
        
        guard let mainPart = components.first else { return newString.count <= mainPartMaxLenght }
        
        var hasCorrectPrecision: Bool {
            guard components.count == 2 else { return true }
            
            let precision = components.last?.count ?? 0
            return (precision <= self.precision)
        }

        return hasCorrectPrecision && mainPart.count <= mainPartMaxLenght
    }
    
    private func precision(of text: String) -> Int {
        let components = text.components(separatedBy: ".")

        guard components.count == 2 else { return 0 }

        return components.last?.count ?? 0
    }
}
