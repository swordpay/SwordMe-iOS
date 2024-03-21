//
//  Double+Addition.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 23.08.22.
//

import UIKit

extension Double {
    
    func formattedNumber(numberStyle: NumberFormatter.Style = .decimal, usesGroupingSeparator: Bool = true, maximumFractionDigits: Int = 2, roundingMode: NumberFormatter.RoundingMode = .down) -> String {
        let formatter = NumberFormatter()

        formatter.usesGroupingSeparator = usesGroupingSeparator
        formatter.locale = Locale(identifier: "en_US")
        formatter.numberStyle = numberStyle
        formatter.maximumFractionDigits = maximumFractionDigits
        formatter.roundingMode = roundingMode

        return formatter.string(from: self as NSNumber) ?? "\(self)"
    }

    func formattedDecimalNumber(maximumFractionDigits: Int = 8, usesGroupingSeparator: Bool = true, roundingMode: NumberFormatter.RoundingMode = .down) -> String {
        guard self.isFinite else { return "0" }

        let formatter = NumberFormatter()

        let newNumber = Decimal(floatLiteral: self)
        
        formatter.usesGroupingSeparator = usesGroupingSeparator
        formatter.locale = Locale(identifier: "en_US")
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = maximumFractionDigits
        formatter.roundingMode = roundingMode

        return formatter.string(from: newNumber as NSNumber) ?? "\(self)"
    }

    func roundToPresentableFormat(powerdBy precision: Int = 8) -> Double {
        let divisor = pow(10.0, Double(precision))

        return (self * divisor).rounded() / divisor
    }
    
    func attributedBalance(currency: String = "€") -> NSAttributedString {
        let currentTheme = ThemeProvider.currentTheme
        let fontSize: CGFloat = UIScreen.hasSmallScreen ? 42 : 48
        let mainPart = NSMutableAttributedString(string: "\(currency) \(self)",
                                                 attributes: [.font: currentTheme.fonts.medium(ofSize: fontSize, family: .poppins),
                                                              .foregroundColor: currentTheme.colors.textColor])
        return mainPart
    }
    
    func bringToPresentableFormat(usesGroupingSeparator: Bool = true, maximumFractionDigits: Int = 2, roundingMode: NumberFormatter.RoundingMode = .down) -> String {
        let formattedNumber = self.formattedNumber(numberStyle: .decimal,
                                                   usesGroupingSeparator: usesGroupingSeparator,
                                                   maximumFractionDigits: maximumFractionDigits, roundingMode: roundingMode)
        
        guard let number = formattedNumber.formattedDecimalNumber(usesGroupingSeparator: usesGroupingSeparator, roundingMode: roundingMode),
              number != 0 else {
            return "\(formattedDecimalNumber(usesGroupingSeparator: usesGroupingSeparator, roundingMode: roundingMode))"
        }
        
        return "\(formattedNumber)"
    }
    
    var isValidAmount: Bool {
        guard self >= 1 && self <= 1000000 else { return false }
        
        let number = "\(self)"
        let components = number.components(separatedBy: ".")
        
        if components.count > 1,
           let precision = components.last?.count,
           precision > 6 {
            return false
        }

        return true
    }
    
    func setCorrectPrecision(_ precision: Int) -> Double {
        let formattedNumber = String(format: "%.\(precision)f", self)

        return Double(formattedNumber) ?? self
    }
}

extension String {
    func formattedDecimalNumber(usesGroupingSeparator: Bool = true, maximumFractionDigits: Int = 2, roundingMode: NumberFormatter.RoundingMode = .down) -> Double? {
        let formatter = NumberFormatter()

        formatter.usesGroupingSeparator = usesGroupingSeparator
        formatter.locale = Locale(identifier: "en_US")
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = maximumFractionDigits
        formatter.roundingMode = roundingMode

        return formatter.number(from: self) as? Double
    }
}
