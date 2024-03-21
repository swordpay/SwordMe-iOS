//
//  ForgotPasswordViewController.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 25.01.23.
//

import UIKit

final class ForgotPasswordViewController: GenericStackViewController<ForgotPasswordViewModel, ForgotPasswordStackView> {
    
    // MARK: - Properties
    override var shouldEmbedInScrollView: Bool { return true }

    override var footerContainerViewInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: -10, right: -20)
    }

    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupFooterView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
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
    
    override func bindViewModel() {
        super.bindViewModel()
        
        bindToSubmitionCompletion()
        bindToTwoFactorAuthenticationPublisher()
    }
    
    private func bindToSubmitionCompletion() {
        viewModel.requestSubmitionCompletion
            .sink { [ weak self ] in
                self?.showForgotPasswordSuccessAlert()
            }
            .store(in: &cancellables)
    }
    
    private func bindToTwoFactorAuthenticationPublisher() {
        viewModel.twoFactorAuthenticationPublisher
            .sink { [ weak self ] phoneNumber in
                self?.goToTwoFactorAuthenticationScreen(phoneNumber: phoneNumber)
            }
            .store(in: &cancellables)
    }

    // MARK: - Navigation
        
    private func showForgotPasswordSuccessAlert() {
        let alertModel = AlertModel(title: Constants.Localization.Common.information,
                                    message: Constants.Localization.Authentication.forgotPasswordAlertMessage,
                                    preferredStyle: .alert,
                                    actions: [.ok],
                                    animated: true)
        let destination = AlertDestination.alert(model: alertModel, presentationCompletion: nil) { [ weak self ] _ in
            self?.navigator.goTo(BackDestination.dismiss(animated: true, completion: nil))
        }

        navigator.goTo(destination)
    }
    
    private func goToTwoFactorAuthenticationScreen(phoneNumber: String) {
        navigator.goTo(PhoneNumberDestination.verifyCode(phoneNumber,
                                                         verificationReason: .changePassword,
                                                         destination: .resetPassword))
    }
}
