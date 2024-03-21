//
//  BirthDateManipulator.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 30.01.23.
//

final class BirthDateManipulator: TextManipulating {
    func manipulate(_ text: String) -> String {
        let newText = text.replacingOccurrences(of: "/", with: "")

        guard text.count < 10 else { return String(text.prefix(10)) }

        var mutableText = ""

        for (index, char) in newText.enumerated() {
            if index == 2 || index == 4 {
                mutableText.append("/")
            }
            mutableText.append(char)
        }

        return mutableText.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
