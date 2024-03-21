//
//  String+Addition.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 21.06.22.
//

import UIKit

extension String {
    var localized: String {
        NSLocalizedString(self,
                          tableName: "SwordLocalizable",
                          bundle: Constants.mainBundle, comment: "")
    }

    func localized(with param: [CVarArg]) -> String {
        return String(format: localized, arguments: param)
    }
}

extension String {
    public func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
    
        return ceil(boundingBox.height)
    }

    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)

        return ceil(boundingBox.width)
    }
}

public extension String {
    func detectedURL() -> URL? {
        guard let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue) else { return nil }
        
        let matches = detector.matches(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count))

        for match in matches {
            guard let range = Range(match.range, in: self) else { continue }
            let url = self[range]

            return URL(string: String(url))
        }

        return nil
    }
}

// MARK: - Date

extension String {
    func toDate(with format: String = Constants.DateFormat.yyyymmdd_dashed) -> Date? {
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = format
//        dateFormatter.locale = 12en_US

        return dateFormatter.date(from: self)
    }
    
    // TODO: - check date formats
    func toCommonFormattedDate(currnetFormat: String = Constants.DateFormat.mmddyy_slashed) -> String {
        guard let date = toDate(with: currnetFormat) else { return self }
        
        let dateFormatter = DateFormatter()

        dateFormatter.locale = .en_US
        dateFormatter.dateFormat = Constants.DateFormat.mmddyy_slashed
        
        let formattedDate =  dateFormatter.string(from: date)
        
        return formattedDate
    }
}

extension String {
    func attributedBalance(currency: String = "€") -> NSAttributedString {
        let currentTheme = ThemeProvider.currentTheme
        let fontSize: CGFloat = UIScreen.hasSmallScreen ? 42 : 48
        let mainPart = NSMutableAttributedString(string: "\(currency) \(self)",
                                                 attributes: [.font: currentTheme.fonts.medium(ofSize: fontSize, family: .poppins),
                                                              .foregroundColor: currentTheme.colors.textColor])
        return mainPart
    }

}

extension String {
    func preprocessSVGWithoutDefs() -> String {
        return replacingOccurrences(of: "<defs>.*?</defs>", with: "",
                                    options: .regularExpression)

    }
}
