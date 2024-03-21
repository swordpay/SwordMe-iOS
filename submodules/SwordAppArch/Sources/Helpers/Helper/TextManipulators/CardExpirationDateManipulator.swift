//
//  CardExpirationDateManipulator.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 19.12.22.
//

import Foundation

final class CardExpirationDateManipulator: TextManipulating {
    func manipulate(_ text: String) -> String {
        let newText = text.replacingOccurrences(of: " / ", with: "")

        guard newText.count <= 4 else { return newText }
        var mutableText = ""

        for (index, char) in newText.enumerated() {
            if index == 2 {
                mutableText.append(" / ")
            }
            mutableText.append(char)
        }

        return mutableText.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
