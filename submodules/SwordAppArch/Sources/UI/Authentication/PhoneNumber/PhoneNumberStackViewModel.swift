//
//  PhoneNumberStackViewModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 07.12.22.
//

import Combine
import Foundation

public final class PhoneNumberStackViewModel {
    var sendCodeButtonPublisher: PassthroughSubject<Void, Never> = PassthroughSubject()
    private var cancellables: Set<AnyCancellable> = []
    let sendCodeButtonValidationPublisher: CurrentValueSubject<Bool, Never> = CurrentValueSubject(false)
    public let verificationReason: PhoneNumberVerificationReason
    
    var title: String {
        switch verificationReason {
        case .registration, .verification:
            return Constants.Localization.Authentication.phoneNumberTitle
        case .twoFactorAuthentication, .changePassword:
            return Constants.Localization.Authentication.phoneNumberTwoFactorAuthTitle
        }
    }
    
    var description: String {
        switch verificationReason {
        case .registration:
            return Constants.Localization.Authentication.phoneNumberRegDescription
        case .verification:
            return Constants.Localization.Authentication.phoneNumberDescription
        case .twoFactorAuthentication, .changePassword:
            return Constants.Localization.Authentication.phoneNumberTwoFactorAuthDescription
        }
    }
    
    lazy var phoneNumberTextFieldModel: ValidatableTextFieldModel = {
        let model = ValidatableTextFieldModel(text: "",
                                              placeholder: "\(Constants.Localization.Common.phoneNumber)",
                                              isEditable: true,
                                              keyboardType: .phonePad,
                                              returnKeyType: .done,
                                              validator: PhoneNumberValidator(),
                                              isSecureTextEntryEnabled: false,
                                              nextTextFieldModel: nil,
                                              prefix: "+ ")

        return model
    }()

    lazy var sendCodeButtonSetupModel: GradientedButtonModel = {
        return GradientedButtonModel(title: Constants.Localization.Common.continue,
                                     hasBorders: false,
                                     isActive: true) { [ weak self ] in
            self?.sendCodeButtonPublisher.send(())
        }
    }()

    public init(verificationReason: PhoneNumberVerificationReason) {
        self.verificationReason = verificationReason

        bindToTextFieldValidations()
    }
    
    private func bindToTextFieldValidations() {
        phoneNumberTextFieldModel.isValid
            .sink(receiveValue: { [ weak self ] isPhoneNumberValid in
                self?.sendCodeButtonValidationPublisher.send(isPhoneNumberValid)
            })
            .store(in: &cancellables)
    }
}
