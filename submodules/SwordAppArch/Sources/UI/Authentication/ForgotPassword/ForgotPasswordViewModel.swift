//
//  ForgotPasswordViewModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 25.01.23.
//

import UIKit
import Combine

struct ForgotPasswordViewModelInputs {
    let forgotPasswordService: ForgotPasswordServicing
}

final class ForgotPasswordViewModel: BaseViewModel<ForgotPasswordViewModelInputs>, StackViewModeling {
    var setupModel: CurrentValueSubject<ForgotPasswordStackViewModel?, Never> = CurrentValueSubject(.init())
    var requestSubmitionCompletion: PassthroughSubject<Void, Never> = PassthroughSubject()
    var twoFactorAuthenticationPublisher: PassthroughSubject<String, Never> = PassthroughSubject()

    var resetPasswordOption: ResetPasswordOption = .phone
    
    lazy var submitButtonViewModel: GradientedButtonModel = {
        return GradientedButtonModel(title: Constants.Localization.Common.submit,
                                     hasBorders: false,
                                     isActive: false,
                                     action: { [ weak self ] in
            self?.submitForgotPasswordRequest()
        })
    }()

    override init(inputs: ForgotPasswordViewModelInputs) {
        super.init(inputs: inputs)
        
        bindToPasswordResetOption()
        bindToUserCredentialsValidation()
    }
    
    
    private func submitForgotPasswordRequest() {
        guard let login = setupModel.value?.userCredentialsTextFieldModel.currentText else { return }
        
        let route = ForgotPasswordParams(login: login)
        isLoading.send(true)
        
        inputs.forgotPasswordService.fetch(route: route)
            .receive(on: RunLoop.main)
            .sink { [ weak self ] completion in
                guard let self else { return }

                self.isLoading.send(false)

                if case let .failure(error) = completion {
                    self.error.send(error)
                }
            } receiveValue: { response in
                print("Forgot password response \(response)")
                AppData.accessToken = response.data.accessToken
                UIPasteboard.general.string = response.data.link // TODO: Remove import foundation

                if self.resetPasswordOption == .phone {
                    self.twoFactorAuthenticationPublisher.send(login)
                } else {
                    self.requestSubmitionCompletion.send(())
                }

            }
            .store(in: &cancellables)
    }
    
    // MARK: - Binding
    
    private func bindToPasswordResetOption() {
        setupModel.value?.resetPasswordOptionSegmentedControlViewModel.selectedIndex
            .sink { [ weak self ] selectedIndex in
                self?.resetPasswordOption = selectedIndex == 0 ? .phone : .email
            }
            .store(in: &cancellables)
    }
    
    private func bindToUserCredentialsValidation() {
        setupModel.value?.userCredentialsTextFieldModel.isValid
            .sink { [ weak self ] isValid in
                self?.submitButtonViewModel.isActive.send(isValid)
            }
            .store(in: &cancellables)
    }
}
