//
//  ResetPasswordStackView.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 26.01.23.
//

import UIKit

public final class ResetPasswordStackView: SetupableStackView {
    // MARK: - IBOutlets
    
    @IBOutlet private weak var resetPasswordLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var passwordTextFieldHolderView: UIView!
    @IBOutlet private weak var repeatPasswordTextFieldHolderView: UIView!
    @IBOutlet private weak var skipButton: UIButton!
    
    // MARK: - Properties
    private var model: ResetPasswordStackViewModel!
    
    // MARK: - Setup UI

    public func setup(with model: ResetPasswordStackViewModel) {
        self.model = model
        
        skipButton.setTitle(Constants.Localization.Common.skip, for: .normal)
        resetPasswordLabel.text = Constants.Localization.Authentication.resetPasswordTitle
        descriptionLabel.text = Constants.Localization.Authentication.resetPasswordDescription
        setupTextField(with: model.passwordTextFieldModel, in: passwordTextFieldHolderView)
        setupTextField(with: model.repeatPasswordTextFieldModel, in: repeatPasswordTextFieldHolderView)
    }
    
    private func setupTextField(with model: ValidatableTextFieldModel, in parentView: UIView) {
        guard let textField = ValidatableTextField.loadFromNib() else { return }

        textField.setup(with: model)
        textField.translatesAutoresizingMaskIntoConstraints = false
        parentView.addSubview(textField)
        textField.addBorderConstraints(constraintSides: .all)
    }

    @IBAction private func skipButtonTouchUp(_ sender: UIButton) {
        model.skipButtonPublisher.send(())
    }
}
