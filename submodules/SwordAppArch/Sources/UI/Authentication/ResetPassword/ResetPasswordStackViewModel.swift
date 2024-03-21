//
//  ResetPasswordStackViewModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 26.01.23.
//

import Combine
import Foundation

public final class ResetPasswordStackViewModel {
    private var cancellables: Set<AnyCancellable> = []
    private let repeatPasswordValidator = RepeatPasswordValidator()

    var allFieldsValidationPublisher: PassthroughSubject<Bool, Never> = PassthroughSubject()
    var skipButtonPublisher: PassthroughSubject<Void, Never> = PassthroughSubject()
    
    lazy var passwordTextFieldModel: ValidatableTextFieldModel = {
        let model = ValidatableTextFieldModel(text: "",
                                              placeholder: "\(Constants.Localization.Common.password)",
                                              isEditable: true,
                                              keyboardType: .default,
                                              returnKeyType: .next,
                                              style: .dark,
                                              validator: RequiredFieldValidator(minLenght: 2, maxLenght: 200),
                                              isSecureTextEntryEnabled: true,
                                              nextTextFieldModel: repeatPasswordTextFieldModel)

        return model
    }()
    
    lazy var repeatPasswordTextFieldModel: ValidatableTextFieldModel = {
        let model = ValidatableTextFieldModel(text: "",
                                              placeholder: "\(Constants.Localization.Authentication.repeatPassword)",
                                              isEditable: true,
                                              keyboardType: .default,
                                              returnKeyType: .done,
                                              style: .dark,
                                              validator: repeatPasswordValidator,
                                              isSecureTextEntryEnabled: true)

        return model
    }()

    init() {
        bindToPasswordText()
        bindToTextFieldValidations()
    }
    
    // MARK: - Bindin
    
    private func bindToTextFieldValidations() {
        Publishers.CombineLatest(passwordTextFieldModel.isValid,
                                 repeatPasswordTextFieldModel.isValid)
        .map { [ weak self ] passwordIsValid, repeatPasswordIsValid in
            guard let self = self else { return false }
            
            return passwordIsValid
                        && repeatPasswordIsValid
                        && (self.passwordTextFieldModel.text.value == self.repeatPasswordTextFieldModel.text.value)
        }
        .sink(receiveValue: { [ weak self ] areAllFieldsValid in
            self?.allFieldsValidationPublisher.send(areAllFieldsValid)
        })
        .store(in: &cancellables)
    }

    private func bindToPasswordText() {
        passwordTextFieldModel.text
            .sink { [ weak self ] password in
                guard let self = self else { return }

                self.validateRepeatPassword(mainPassword: password)
            }
            .store(in: &cancellables)
    }
    
    private func validateRepeatPassword(mainPassword: String?) {
        repeatPasswordValidator.originalPassword = mainPassword
        let isRepeatPasswordValid = repeatPasswordValidator.validate(self.repeatPasswordTextFieldModel.text.value)
        repeatPasswordTextFieldModel.externalValidationPublisher.send(isRepeatPasswordValid)
    }
}
