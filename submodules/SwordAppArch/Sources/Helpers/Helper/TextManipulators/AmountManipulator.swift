//
//  AmountManipulator.swift
//  SwordAppArch
//
//  Created by Tigran Simonyan on 18.01.24.
//

import Foundation

final class AmountManipulator: TextManipulating {
    var maximumFractionDigits: Int
    
    init (maximumFractionDigits: Int = 2) {
        self.maximumFractionDigits = maximumFractionDigits
    }
    
    func manipulate(_ text: String) -> String {
        var mutableString = text.replacingOccurrences(of: "[^\\d.,]+", with: "", options: .regularExpression)

        if mutableString.last == "," {
            mutableString.removeLast()
            mutableString.append(".")
        }
        
        guard mutableString.contains(".") else { return mutableString.replacingOccurrences(of: ",", with: "").formattedDecimalNumber(maximumFractionDigits: 0)?.bringToPresentableFormat(maximumFractionDigits: 0) ?? mutableString }
        
        let textComponents = mutableString.components(separatedBy: ".")
        
        let mainPart = textComponents.first!.replacingOccurrences(of: ",", with: "").formattedDecimalNumber(maximumFractionDigits: 0)?.bringToPresentableFormat(maximumFractionDigits: 0) ?? textComponents.first!
        
        return mainPart + "." + textComponents.last!.prefix(maximumFractionDigits)
    }
}
