//
//  ForgotPasswordStackView.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 25.01.23.
//

import UIKit
import Combine

final class ForgotPasswordStackView: SetupableStackView {
    // MARK: - IBOutlets

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var emailTextFieldHolder: UIView!
    @IBOutlet private weak var segmentedControlHolderView: UIView!

    // MARK: - Properties

    private var model: ForgotPasswordStackViewModel!
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Setup UI
    
    func setup(with model: ForgotPasswordStackViewModel) {
        self.model = model
        
        titleLabel.text = Constants.Localization.Authentication.forgotPassword

        setupEmailTextField()
        setupSegmentedControl()
        
        bindToSelectedOption()
    }
    
    private func setupEmailTextField() {
        guard let textField = ValidatableTextField.loadFromNib() else { return }

        textField.setup(with: model.userCredentialsTextFieldModel)
        textField.translatesAutoresizingMaskIntoConstraints = false
        emailTextFieldHolder.addSubview(textField)
        textField.addBorderConstraints(constraintSides: .all)
    }
    
    private func setupSegmentedControl() {
        guard let segmentedControl = SegmentedControl.loadFromNib() else { return }

        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControlHolderView.addSubview(segmentedControl)
        
        segmentedControl.addBorderConstraints(constraintSides: .all)
        segmentedControl.setup(with: model.resetPasswordOptionSegmentedControlViewModel)
    }
    
    // MARK: - Binding
    
    private func bindToSelectedOption() {
        model.resetPasswordOptionSegmentedControlViewModel.selectedIndex
            .sink { [ weak self ] selectedIndex in
                self?.descriptionLabel.text = selectedIndex == 0 ? Constants.Localization.Authentication.forgotPasswordDescription
                                                                : Constants.Localization.Authentication.forgotPasswordEmailDescription
            }
            .store(in: &cancellables)
    }
}
