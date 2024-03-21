//
//  CodeVerificationViewModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 10.06.22.
//

import Combine
import Foundation

final class CodeVerificationViewModel {
    let validCodeLenght: Int
    let areAllNumbersFilled: CurrentValueSubject<Bool, Never> = CurrentValueSubject(false)

    lazy private(set) var filledNumbers: [String] = Array(repeating: "", count: validCodeLenght)

    lazy var codeVerificationItemModels: [CodeVerificationItemViewModel] = Array(repeating: .init(), count: validCodeLenght)
    
    init(validCodeLenght: Int) {
        self.validCodeLenght = validCodeLenght
    }

    func updateAllNumbers(_ numbers: [String]) {
        filledNumbers = numbers
        validateFilledNumbers()
    }

    func updateNumber(_ number: String, at index: Int) {
        guard index >= 0 && index < validCodeLenght else { return }

        filledNumbers[index] = number
        validateFilledNumbers()
    }

    func cleanExistingCode() {
        for index in 0..<filledNumbers.count {
            filledNumbers[index] = ""
        }
    }

    private func validateFilledNumbers() {
        var isValidCode = true

        filledNumbers.forEach { isValidCode = !$0.isEmpty && isValidCode }
        areAllNumbersFilled.send(isValidCode)
    }
}
