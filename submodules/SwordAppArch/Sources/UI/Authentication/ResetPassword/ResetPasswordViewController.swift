//
//  ResetPasswordViewController.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 26.01.23.
//

import UIKit
import TelegramCore

public final class ResetPasswordViewController: GenericStackViewController<ResetPasswordViewModel, ResetPasswordStackView> {
    // MARK: - Properties
    public override var shouldEmbedInScrollView: Bool { return true }

    public override var footerContainerViewInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: -30, right: -20)
    }

    // MARK: - Lifecycle Methods
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupFooterView()
    }
    
    // MARK: - Setup UI
    
    private func setupFooterView() {
        let nextButton = GradientedButton()
        
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.setup(with: viewModel.submitButtonViewModel)
        
        NSLayoutConstraint.activate([
            nextButton.heightAnchor.constraint(equalToConstant: Constants.defaultButtonHeight)
        ])

        self.footerView = nextButton
    }

    // MARK: - Binding
    
    public override func bindViewModel() {
        super.bindViewModel()
        
        bindToResetPasswordCompletion()
        bindToSubmitNewPasswordCompletion()
    }
    
    private func bindToResetPasswordCompletion() {
        viewModel.resetPasswordCompletion
            .sink { [ weak self ] isSucceded in
                self?.showCompletionAlert(isSucceded: isSucceded)
            }
            .store(in: &cancellables)
    }
    
    private func bindToSubmitNewPasswordCompletion() {
        viewModel.submitNewPasswordCompletion
            .sink { [ weak self ] in
                self?.showPasswordHintAlert()
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Navigation
    
    private func showCompletionAlert(isSucceded: Bool) {
        let message = viewModel.resetPasswordCompletionMessage(isSucceded: isSucceded)
        let alertModel = AlertModel(title: Constants.Localization.Authentication.resetPassword, message: message, preferredStyle: .alert, actions: [.ok], animated: true)
        let alertDestination = AlertDestination.alert(model: alertModel, presentationCompletion: nil) { [ weak self ] _ in
            if isSucceded {
                self?.navigator.goTo(BackDestination.dismissToRoot(animated: true, completion: nil))
            }
        }
        
        navigator.goTo(alertDestination)
    }
    
    private func showPasswordHintAlert() {
        let model = AlertModel(title: "Hint",
                               message: "You can create an optional hint for your password",
                               preferredStyle: .alert,
                               inputModel: .init(isInputable: true,
                                                 placeholder: "Hint (optional)",
                                                 keyboardType: .default,
                                                 inputAccessoryView: nil,
                                                 delegate: nil),
                               actions: [.dynamic(title: "Skip", image: nil, style: .default, tag: 0),
                                         .input(title: "Next")],
                               animated: true)
        let destination = AlertDestination.alert(model: model, forcePresentFromRoot: true) { [ weak self ] hint in
            self?.viewModel.submitNewPassword(hint: hint)
        } presentationCompletion: {
            
        } actionCompletion: { [ weak self ] type in
            guard case .dynamic = type else { return }
            
            self?.viewModel.submitNewPassword(hint: nil)
        }

        navigator.goTo(destination)
    }
}
