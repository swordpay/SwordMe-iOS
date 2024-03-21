//
//  TFAPasswordViewModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 11.08.23.
//

import Combine
import Foundation

public final class TFAPasswordViewModel: BaseViewModel<Void>, StackViewModeling {
    public var setupModel: CurrentValueSubject<TFAPasswordStackViewModel?, Never>
    
    public override var shouldBindToAuthorizationManagerLoading: Bool { return true }
    
    public var loginWithPassword: ((String) -> Void)?
    public var forgot: (() -> Void)?
    public var reset: (() -> Void)?
    public var back: (() -> Void)?

    lazy var nextButtonViewModel: GradientedButtonModel = {
        return GradientedButtonModel(title: Constants.Localization.Common.next,
                                     hasBorders: false,
                                     isActive: false,
                                     action: { [ weak self ] in
            guard let self,
                  let password = setupModel.value?.passwordTextFieldModel.text.value else { return }
            
            self.loginWithPassword?(password)
        })
    }()

    init(passwordHint: String?, state: TFAPasswordStackViewModel.State) {
        
        self.setupModel = .init(.init(passwordHint: passwordHint, state: state))
        
        super.init(inputs: ())
        
        bindToSetupModelActions()
        bindToPasswordValidation()
    }

    private func bindToSetupModelActions() {
        setupModel.value?.forgotPasswordButtonHandler
            .sink { [ weak self ] in
                self?.forgot?()
            }
            .store(in: &cancellables)
        
        setupModel.value?.resetAccountButtonHandler
            .sink { [ weak self ] in
                self?.reset?()
            }
            .store(in: &cancellables)

    }
    
    private func bindToPasswordValidation() {
        setupModel.value?.passwordTextFieldModel.isValid
            .sink { [ weak self ] isValid in
                self?.nextButtonViewModel.isActive.send(isValid)
            }
            .store(in: &cancellables)
    }

}
