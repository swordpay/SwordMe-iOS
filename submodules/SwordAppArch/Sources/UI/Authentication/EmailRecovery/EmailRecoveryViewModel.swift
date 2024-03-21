//
//  EmailRecoveryViewModel.swift
//  SwordAppArch
//
//  Created by Tigran Simonyan on 11.08.23.
//

import Combine
import Foundation

public final class EmailRecoveryViewModel: BaseViewModel<Void>, StackViewModeling {
    public var setupModel: CurrentValueSubject<EmailRecoveryStackViewModel?, Never>
    
    
    public var continueWithCode: ((String) -> Void)?
    public var cantAccessEmail: (() -> Void)?
    public var resendCode: (() -> Void)?

    lazy var nextButtonViewModel: GradientedButtonModel = {
        return GradientedButtonModel(title: Constants.Localization.Common.next,
                                     hasBorders: false,
                                     isActive: false,
                                     action: { [ weak self ] in
            guard let self,
                  let code = setupModel.value?.codeTextFieldModel.text.value else { return }
            
            self.continueWithCode?(code)
        })
    }()

    public init(email: String) {
        self.setupModel = .init(.init(email: email))
        
        super.init(inputs: ())
        
        bindToCodeValidation()
        bindToSetupModelActions()
    }
    
    private func bindToSetupModelActions() {
        setupModel.value?.cantAccessEmailButtonHandler
            .sink { [ weak self ] in
                self?.cantAccessEmail?()
            }
            .store(in: &cancellables)
        
        setupModel.value?.resendCodeButtonHandler
            .sink { [ weak self ] in
                self?.resendCode?()
            }
            .store(in: &cancellables)

    }
    
    private func bindToCodeValidation() {
        setupModel.value?.codeTextFieldModel.isValid
            .sink { [ weak self ] isValid in
                self?.nextButtonViewModel.isActive.send(isValid)
            }
            .store(in: &cancellables)
    }

}
