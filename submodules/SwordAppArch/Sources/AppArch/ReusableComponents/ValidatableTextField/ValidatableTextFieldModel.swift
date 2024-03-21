//
//  ValidatableTextFieldModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 31.05.22.
//

import UIKit
import Combine

enum ValidatableTextFieldStyle {
    case light
    case dark
}

final class ValidatableTextFieldModel {
    private var cancellables: Set<AnyCancellable> = []

    let text: CurrentValueSubject<String?, Never>
    let placeholder: CurrentValueSubject<String, Never>
    let inputLimit: InputLimit
    let isEditable: Bool
    let keyboardType: CurrentValueSubject<UIKeyboardType, Never>
    let returnKeyType: UIReturnKeyType
    var validator: TextValidating
    let manipulator: TextManipulating?
    let style: ValidatableTextFieldStyle
    let isSecureTextEntryEnabled: Bool
    let nextTextFieldModel: ValidatableTextFieldModel?
    let prefix: CurrentValueSubject<String?, Never>

    let externalValidationPublisher: PassthroughSubject<Constants.Typealias.TextValidationResult, Never> = PassthroughSubject()
    let externalTextPublisher: PassthroughSubject<String?, Never> = PassthroughSubject()
    let didTextEditBegin: PassthroughSubject<Void, Never> = PassthroughSubject()
    
    let makeFirstResponderPublisher: PassthroughSubject<Bool, Never> = PassthroughSubject()
    let resetTextFieldPublisher: PassthroughSubject<Void, Never> = PassthroughSubject()

    var isValid: CurrentValueSubject<Bool, Never>

    var textChecker: TextChangeChecking?
    
    var isKeyboardNumerical: Bool {
        let numericalKeyboardTypes: [UIKeyboardType] = [.numberPad, .phonePad]

        return numericalKeyboardTypes.contains(keyboardType.value)
    }

    var attributedPlaceholder: NSAttributedString {
        let theme = ThemeProvider.currentTheme
        let placeholderColor = theme.colors.lightGray2
        

        return NSAttributedString(string: placeholder.value,
                                  attributes: [.foregroundColor: placeholderColor,
                                               .font: theme.fonts.regular(ofSize: 22, family: .poppins)])
    }
    
    var currentText: String? {
        guard let text = text.value else { return nil }
        
        let unwrapedPrefix = prefix.value ?? ""
        
        return unwrapedPrefix.trimmingCharacters(in: .whitespacesAndNewlines) + text
    }

    init(text: String? = nil,
         placeholder: String,
         inputLimit: InputLimit = .none,
         isEditable: Bool = true,
         keyboardType: UIKeyboardType,
         returnKeyType: UIReturnKeyType,
         style: ValidatableTextFieldStyle = .light,
         validator: TextValidating,
         manipulator: TextManipulating? = nil,
         isSecureTextEntryEnabled: Bool,
         connectedValidableTextFieldModel: ValidatableTextFieldModel? = nil,
         nextTextFieldModel: ValidatableTextFieldModel? = nil,
         prefix: String? = nil,
         textChecker: TextChangeChecking? = nil) {
        let isValid = validator.validate(text).0 == .success

        self.text = CurrentValueSubject(text)
        self.placeholder = CurrentValueSubject(placeholder)
        self.inputLimit = inputLimit
        self.isEditable = isEditable
        self.keyboardType = CurrentValueSubject(keyboardType)
        self.returnKeyType = returnKeyType
        self.style = style
        self.validator = validator
        self.manipulator = manipulator
        self.isSecureTextEntryEnabled = isSecureTextEntryEnabled
        self.nextTextFieldModel = nextTextFieldModel
        self.isValid = CurrentValueSubject(isValid)
        self.prefix = CurrentValueSubject(prefix)
        self.textChecker = textChecker

        bindToText()
    }

    // MARK: - Binding

    private func bindToText() {
        text
            .map(validator.validate(_:))
            .map { $0.0 == .success }
            .sink { [ weak self ] isValid in
                self?.isValid.send(isValid)
            }
            .store(in: &cancellables)
    }
}

extension ValidatableTextFieldModel {
    enum InputLimit {
        case none
        case lenght(Int)
    }
}
