//
//  NSMutableAttributedString+Addition.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 23.06.22.
//

import UIKit

extension NSMutableAttributedString {
    @discardableResult
    public func setAsLink(textToFind: String, linkURL: String) -> Bool {
        guard let url = URL(string: linkURL) else { return false }

        let foundRange = self.mutableString.range(of: textToFind)

        guard foundRange.location != NSNotFound else { return false }

        self.addAttribute(.link, value: url, range: foundRange)

        return true
    }
}
