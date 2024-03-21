//
//  VerifyPhoneNumberViewController.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 07.12.22.
//

import UIKit
import Display
import TelegramPresentationData

public final class VerifyPhoneNumberViewController: GenericStackViewController<VerifyPhoneNumberViewModel, VerifyPhoneNumberStackView> {
    // MARK: - Properties
    
    public override var shouldEmbedInScrollView: Bool { return false }
    
    public var presentationData: PresentationData?
    
    public var shouldResetState: Bool = true
    
    // MARK: - Lifecycle Methods
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if shouldResetState {
            viewModel.back?()
        }
    }

    // MARK: - Setup UI

    private func setupNavigationBar() {
        navigationBar?.backPressed = { [ weak self ] in
            self?.showBackAlert()
        }
    }
    
    public func resetCode() {
        stackView.cleanExsitingCode()
    }
    
    // MARK: - Binding
    
    public override func bindViewModel() {
        super.bindViewModel()

        bindToCodeVerificationCompletion()
    }
    
    private func bindToCodeVerificationCompletion() {
        // TODO: - Handle code
    }

    // MARK: - Navigation
    
    private func showBackAlert() {
        guard let presentationData else { return }

        let text = presentationData.strings.Login_CancelPhoneVerification
        let proceed = presentationData.strings.Login_CancelPhoneVerificationContinue
        let stop = presentationData.strings.Login_CancelPhoneVerificationStop

        present(standardTextAlertController(theme: AlertControllerTheme(presentationData: presentationData), title: nil, text: text, actions: [TextAlertAction(type: .genericAction, title: proceed, action: {
        }), TextAlertAction(type: .defaultAction, title: stop, action: { [ weak self ] in
            self?.viewModel.back?()
        })]), in: .window(.root))
    }

    public func showWrongCodeAlert(text: String) {
        let alertModel = AlertModel(title: text, preferredStyle: .alert, actions: [.ok], animated: true)
        let alertDestination = AlertDestination.alert(model: alertModel, forcePresentFromRoot: true, presentationCompletion: nil, actionCompletion: nil)
        
        navigator.goTo(alertDestination)
    }
    
    private func popViewController() {
        navigator.goTo(BackDestination.pop(animated: true))
    }
        
    private func goToResetPasswordScreen() {
        navigator.goTo(AuthenticationDestination.resetPassword)
    }
    
    private func goToNotificationAccessScreen() {
        navigator.goTo(CommonDestination.notificationPermission)
    }
}
