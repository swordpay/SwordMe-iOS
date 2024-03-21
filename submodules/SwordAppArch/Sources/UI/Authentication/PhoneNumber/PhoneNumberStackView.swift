//
//  PhoneNumberStackView.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 07.12.22.
//

import UIKit
import Combine

public final class PhoneNumberStackView: SetupableStackView {
    // MARK: - IBOutlets

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var phoneNumberHolderView: UIView!
    @IBOutlet private weak var sendCodeButtonHolderView: UIView!
    @IBOutlet private weak var termsOfUseHolderView: UIView!
    
    @IBOutlet private weak var sendCodeButtonHeightConstraint: NSLayoutConstraint!

    // MARK: - Properties

    private var model: PhoneNumberStackViewModel!
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Setup UI

    public func setup(with model: PhoneNumberStackViewModel) {
        self.model = model
        
        sendCodeButtonHeightConstraint.constant = Constants.defaultButtonHeight
        setupLabelsTexts()
        setupSendCodeButton()
        setupPhoneNumberTextField()
        bindToSendCodeButtonValidation()
    }
    
    private func setupLabelsTexts() {
        titleLabel.text = model.title
        descriptionLabel.text = model.description
    }

    private func setupSendCodeButton() {
        let button = GradientedButton()
        
        button.setup(with: model.sendCodeButtonSetupModel)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setCornerRadius()
        sendCodeButtonHolderView.addSubview(button)
        button.addBorderConstraints(constraintSides: .all)
    }

    private func setupPhoneNumberTextField() {
        guard let textField = ValidatableTextField.loadFromNib() else { return }

        textField.setup(with: model.phoneNumberTextFieldModel)
        textField.translatesAutoresizingMaskIntoConstraints = false
        phoneNumberHolderView.addSubview(textField)
        textField.addBorderConstraints(constraintSides: .all)
    }

    // MARK: - Binding
    
    private func bindToSendCodeButtonValidation() {
        model.sendCodeButtonValidationPublisher
            .sink { [ weak self ] isValid in
                guard let self = self else { return }

                self.model.sendCodeButtonSetupModel.isActive.send(isValid)
            }
            .store(in: &cancellables)
    }
}
