//
//  EmailRecoveryStackView.swift
//  SwordAppArch
//
//  Created by Tigran Simonyan on 11.08.23.
//

import UIKit

public final class EmailRecoveryStackView: SetupableStackView {
    // MARK: - IBOutlets
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var codeHolderView: UIView!
    @IBOutlet private weak var cantAccessEmailButton: UIButton!
    @IBOutlet private weak var resendCodeButton: UIButton!

    // MARK: - Properties
    
    private var model: EmailRecoveryStackViewModel!

    // MARK: - Setup UI

    public func setup(with model: EmailRecoveryStackViewModel) {
        self.model = model

        titleLabel.text = Constants.Localization.Authentication.recoveryEmailTitle
        descriptionLabel.text = Constants.Localization.Authentication.recoveryEmailDescription(email: model.email)
        
        resendCodeButton.setTitle(Constants.Localization.Authentication.recoveryEmailResendCodeTitle, for: .normal)
        cantAccessEmailButton.setTitle(Constants.Localization.Authentication.cantAccessEmailTilte, for: .normal)

        setupCodeTextField()
    }
    
    private func setupCodeTextField() {
        guard let textField = ValidatableTextField.loadFromNib() else { return }

        textField.setup(with: model.codeTextFieldModel)
        textField.translatesAutoresizingMaskIntoConstraints = false
        codeHolderView.addSubview(textField)
        textField.addBorderConstraints(constraintSides: .all)
    }
    
    // MARK: - Actions
    
    @IBAction private func cantAccessEmailButtonTouchUp(_ sender: UIButton) {
        model.cantAccessEmailButtonHandler.send(())
    }
    
    @IBAction private func resendCodeButtonTouchUp(_ sender: UIButton) {
        model.resendCodeButtonHandler.send(())
    }

}
