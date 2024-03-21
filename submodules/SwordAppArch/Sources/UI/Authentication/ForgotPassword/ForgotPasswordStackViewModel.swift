//
//  ForgotPasswordStackViewModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 25.01.23.
//

import UIKit
import Combine

final class ForgotPasswordStackViewModel {
    private var cancellables: Set<AnyCancellable> = []
    
    lazy var userCredentialsTextFieldModel: ValidatableTextFieldModel = {
        return ValidatableTextFieldModel(placeholder: "\(Constants.Localization.Common.phoneNumber)",
                                         keyboardType: .default,
                                         returnKeyType: .done,
                                         validator: UserCredentialsValidator(),
                                         isSecureTextEntryEnabled: false,
                                         prefix: "+")
    }()
    
    var resetPasswordOptionSegmentedControlViewModel = SegmentedControlSetupModel(models: [
        .init(imageName: Constants.AssetName.Common.phoneIcon,
              title: Constants.Localization.Common.phone,
              isSelected: CurrentValueSubject(true)),
        .init(imageName: Constants.AssetName.Common.emailIcon,
              title: Constants.Localization.Common.email,
              isSelected: CurrentValueSubject(false))
    ])

    init() {
        bindToResetPasswordOptionSegmentedControlViewModel()
    }
    
    // MARK: - Binding
    
    private func bindToResetPasswordOptionSegmentedControlViewModel() {
        resetPasswordOptionSegmentedControlViewModel.selectedIndex
            .sink { [ weak self ] selectedIndex in
                let isPhoneOption = selectedIndex == 0
                let validator: TextValidating = isPhoneOption ? PhoneNumberValidator() : EmailValidator()
                let currentText = self?.userCredentialsTextFieldModel.text.value
                let currentValidationState = validator.validate(currentText)
                let placeholder = isPhoneOption ? Constants.Localization.Common.phoneNumber
                                                : Constants.Localization.Common.email
                let keyboardType: UIKeyboardType = isPhoneOption ? .phonePad : .emailAddress
                let prefix = isPhoneOption ? "+" : nil

                self?.userCredentialsTextFieldModel.placeholder.send(placeholder)
                self?.userCredentialsTextFieldModel.keyboardType.send(keyboardType)
                self?.userCredentialsTextFieldModel.validator = validator
                self?.userCredentialsTextFieldModel.prefix.send(prefix)
                self?.userCredentialsTextFieldModel.makeFirstResponderPublisher.send(false)
                
                if !(currentText ?? "").isEmpty {
                    self?.userCredentialsTextFieldModel.externalValidationPublisher.send(currentValidationState)
                }
            }
            .store(in: &cancellables)
    }
}
