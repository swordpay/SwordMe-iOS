//
//  CodeVerificationView.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 10.06.22.
//

import UIKit

final class CodeVerificationView: SetupableView {
    typealias SetupModel = CodeVerificationViewModel

    // MARK: - IBOutlets

    @IBOutlet private weak var holderStackView: UIStackView!

    // MARK: - Properties

    private var model: CodeVerificationViewModel!

    // MARK: - Setup UI

    func setup(with model: CodeVerificationViewModel) {
        self.model = model

        setupTextFields()
    }

    private func setupTextFields() {
        let textFields = (0..<model.validCodeLenght).compactMap { createCodeVerificationItemView(tag: $0) }

        for (index, textField) in textFields.enumerated() {
            holderStackView.insertArrangedSubview(textField, at: index)
        }
    }

    private func createCodeVerificationItemView(tag: Int) -> CodeVerificationItemView? {
        guard let itemView = CodeVerificationItemView.loadFromNib(),
              let itemModel = model.codeVerificationItemModels[safe: tag] else { return nil }
        
        itemView.setup(with: itemModel)
        itemView.codeTextField.tag = tag
        itemView.codeTextField.delegate = self
        itemView.codeTextField.deleteDelegate = self

        return itemView
    }

    func cleanExistingCode() {
        holderStackView.arrangedSubviews.enumerated().forEach { (index, view) in
            if let itemView = view as? CodeVerificationItemView {
                itemView.codeTextField.text = nil

                if index == 0 {
                    itemView.codeTextField.becomeFirstResponder()
                }
            }
        }

        model.cleanExistingCode()
    }
}

extension CodeVerificationView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let tag = textField.tag

        activateTextField(at: tag + 1)

        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: string))
                || string.count <= model.validCodeLenght else { return false }

        if string.isEmpty {
            model.updateNumber("", at: textField.tag)

            return true
        }

        if string.count == model.validCodeLenght {
            insertCode(string)

            return false
        }

        if string.count == 1 {
            let shouldChangeCharacters = shouldChangeCharactersOf(exsitingText: textField.text,
                                                                   range: range,
                                                                   replacementString: string)

            if shouldChangeCharacters {
                textField.text = string
                model.updateNumber(string, at: textField.tag)
                activateTextField(at: textField.tag + 1)

                return false
            }
        }

        return false
    }

    private func insertCode(_ string: String) {
        var numbers: [String] = Array(repeating: "", count: model.validCodeLenght)

        for index in 0 ..< string.count {
            let value = string[string.index(string.startIndex, offsetBy: index)]

            model.codeVerificationItemModels[safe: index]?.textToUpdatePublisher.send(String(value))
            numbers[index] = String(value)
        }

        model.updateAllNumbers(numbers)
        endEditing(true)
    }

    private func shouldChangeCharactersOf(exsitingText: String?, range: NSRange, replacementString string: String) -> Bool {
        let currentText = exsitingText ?? ""

        // attempt to read the range they are trying to change, or exit if we can't
        guard let stringRange = Range(range, in: currentText) else { return false }

        // add their new text to the existing text
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

        // make sure the result is under 16 characters
        return updatedText.count <= 1
    }

    private func activateTextField(at index: Int) {
        guard tag < model.validCodeLenght,
              let codeVerificationItemView = holderStackView.arrangedSubviews[safe: index] as? CodeVerificationItemView else { return }

        codeVerificationItemView.codeTextField.becomeFirstResponder()
    }
}

extension CodeVerificationView: DeleteActionTrackingTextFieldDelegate {
    func didTapDeletedInEmptyTextField(_ textField: UITextField) {
        let index = textField.tag
        
        guard index != 0 else { return }
        
        let previousIndex = index - 1
        
        activateTextField(at: previousIndex)
        model.updateNumber("", at: previousIndex)
    }
}
