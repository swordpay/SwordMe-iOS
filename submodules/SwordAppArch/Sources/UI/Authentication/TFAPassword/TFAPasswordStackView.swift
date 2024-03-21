//
//  TFAPasswordStackView.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 11.08.23.
//

import UIKit

public final class TFAPasswordStackView: SetupableStackView {
    // MARK: - IBOutlets
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var passwordHolderView: UIView!
    @IBOutlet private weak var forgotPasswordButton: UIButton!
    @IBOutlet private weak var resetAccountButton: UIButton!

    // MARK: - Properties
    
    private var model: TFAPasswordStackViewModel!

    // MARK: - Setup UI

    public func setup(with model: TFAPasswordStackViewModel) {
        self.model = model

        titleLabel.text = Constants.Localization.Authentication.tfaPasswordTitle
        descriptionLabel.text = Constants.Localization.Authentication.tfaPasswordDescription
        
        forgotPasswordButton.setTitle("\(Constants.Localization.Authentication.forgotPassword)?", for: .normal)
        resetAccountButton.setTitle("\(Constants.Localization.Authentication.resetAccount)", for: .normal)

        setupPasswordTextField()
        
        if model.state == .authorization {
            resetAccountButton.isHidden = true
            forgotPasswordButton.isHidden = true
        } else {
            resetAccountButton.isHidden = model.state == .forgotPassword
        }
    }
    
    public func resetPassord() {
        model.passwordTextFieldModel.externalTextPublisher.send(nil)
    }
    
    private func setupPasswordTextField() {
        guard let textField = ValidatableTextField.loadFromNib() else { return }

        textField.setup(with: model.passwordTextFieldModel)
        textField.translatesAutoresizingMaskIntoConstraints = false
        passwordHolderView.addSubview(textField)
        textField.addBorderConstraints(constraintSides: .all)
    }
    
    // MARK: - Actions
    
    @IBAction private func forgotPasswordButtonTouchUp(_ sender: UIButton) {
        model.forgotPasswordButtonHandler.send(())
    }
    
    @IBAction private func resetAccountButtonTouchUp(_ sender: UIButton) {
        model.resetAccountButtonHandler.send(())
    }
}
