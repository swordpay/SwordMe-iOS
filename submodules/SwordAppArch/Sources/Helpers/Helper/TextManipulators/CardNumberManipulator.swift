//
//  CardNumberManipulator.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 20.12.22.
//

import Foundation

final class CardNumberManipulator: TextManipulating {
    func manipulate(_ text: String) -> String {
        let newText = text.replacingOccurrences(of: " ", with: "")
        var mutableText = text
        
        guard newText.count >= 4 else { return newText }
        
        if newText.count % 4 == 1 {
            let spaceOffset = mutableText.index(mutableText.startIndex, offsetBy: mutableText.count - 1)
            let possibleSpaceOffset = mutableText.index(mutableText.startIndex, offsetBy: mutableText.count - 2)

            if mutableText[possibleSpaceOffset] != " " {
                mutableText.insert(" ", at: spaceOffset)
            }
        }

        return mutableText.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
