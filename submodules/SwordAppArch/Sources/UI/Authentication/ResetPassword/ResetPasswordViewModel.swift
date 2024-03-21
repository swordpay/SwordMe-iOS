//
//  ResetPasswordViewModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 26.01.23.
//

import Combine
import Foundation

public struct ResetPasswordViewModelInputs {
    let resetPasswordService: ResetPasswordServicing
}

public final class ResetPasswordViewModel: BaseViewModel<ResetPasswordViewModelInputs>, StackViewModeling {
    public var setupModel: CurrentValueSubject<ResetPasswordStackViewModel?, Never> = CurrentValueSubject(.init())
    let resetPasswordCompletion: PassthroughSubject<Bool, Never> = PassthroughSubject()
    
    let submitNewPasswordCompletion: PassthroughSubject<Void, Never> = .init()
    public var skip: (() -> Void)?
    public var recoverPassword: ((String, String?) -> Void)?

    lazy var submitButtonViewModel: GradientedButtonModel = {
        return GradientedButtonModel(title: Constants.Localization.Common.submit,
                                     hasBorders: false,
                                     isActive: false,
                                     action: { [ weak self ] in
            self?.submitNewPasswordCompletion.send(())
        })
    }()

    public override init(inputs: ResetPasswordViewModelInputs) {
        super.init(inputs: inputs)
        
        bindToSkipHandler()
        bindToPasswordsValidation()
    }
    
    func resetPasswordCompletionMessage(isSucceded: Bool) -> String {
        return isSucceded ? Constants.Localization.Authentication.resetPasswordSuccessMessage
                          : Constants.Localization.Authentication.resetPasswordFailMessage
    }

    func submitNewPassword(hint: String?) {
        guard let password = setupModel.value?.passwordTextFieldModel.text.value else { return }
        
        recoverPassword?(password, hint)
    }
    
    // MARK: - Binding
    
    private func bindToPasswordsValidation() {
        setupModel.value?.allFieldsValidationPublisher
            .sink { [ weak self ] isValid in
                self?.submitButtonViewModel.isActive.send(isValid)
            }
            .store(in: &cancellables)
    }
    
    private func bindToSkipHandler() {
        setupModel.value?.skipButtonPublisher
            .sink { [ weak self ] in
                self?.skip?()
            }
            .store(in: &cancellables)
    }

}
