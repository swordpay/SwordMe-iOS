//
//  VerifyPhoneNumberStackView.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 07.12.22.
//

import UIKit
import Combine

public final class VerifyPhoneNumberStackView: SetupableStackView {
    
    // MARK: - IBOutlets

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var verificationCodeHolderView: UIView!
    @IBOutlet private weak var resendCodeButton: UIButton!
    @IBOutlet private weak var loginInfoButton: UIButton!
    @IBOutlet private weak var timerLabel: UILabel!

    // MARK: - Properties
    
    private var model: VerifyPhoneNumberStackViewModel!
    private var cancellables: Set<AnyCancellable> = []
    private var codeView: CodeVerificationView?

    // MARK: - Setup UI
    
    public func setup(with model: VerifyPhoneNumberStackViewModel) {
        self.model = model
        
        setupLabelsTexts()
        setupLoginInfoButton()
        setupCodeVerificationView()
        
        disablesInteractiveTransitionGestureRecognizer = true

//        model.startTimer()

//        canResendCode()
//        bindToTimerText()
    }
    
    private func setupLabelsTexts() {
        titleLabel.text = model.title
        resendCodeButton.setTitle(Constants.Localization.Authentication.verifyPhoneNumberResendCode, for: .normal)
        
        titleLabel.font = theme.fonts.bold(ofSize: 26, family: .poppins)
    }
    
    private func setupLoginInfoButton() {
        guard model.isLoginInfoNeeded else {
            loginInfoButton.isHidden = true
            
            return
        }
        
        loginInfoButton.layer.borderColor = theme.colors.gradientDarkBlue.cgColor
        loginInfoButton.layer.borderWidth = 1

        loginInfoButton.setCornerRadius()
        loginInfoButton.setTitle("How can I receive the code?", for: .normal)
        loginInfoButton.isHidden = false
    }

    private func setupCodeVerificationView() {
        guard let codeView = CodeVerificationView.loadFromNib() else { return }
        
        codeView.translatesAutoresizingMaskIntoConstraints = false
        verificationCodeHolderView.addSubview(codeView)
        
        codeView.addBorderConstraints(constraintSides: .all)
        codeView.setup(with: model.verificationCodeViewModel)
        
        self.codeView = codeView
    }
        
    func cleanExsitingCode() {
        codeView?.cleanExistingCode()
    }
    // MARK: - Binding
    
    private func bindToTimerText() {
        model.timerText
            .sink { [ weak self ] remainingTime in
                self?.timerLabel.text = remainingTime
            }
            .store(in: &cancellables)
    }

    private func canResendCode() {
        model.canResendCode
            .sink { [ weak self ] canResend in
                self?.resendCodeButton.isHidden = !canResend
//                self?.timerLabel.isHidden = canResend
            }
            .store(in: &cancellables)
    }

    // MARK: - Actions
    
    @IBAction private func resendButtonTouchUp(_ sender: UIButton) {
        cleanExsitingCode()
        model.resendButtonPublisher.send(())
        model.canResendCode.send(false)
        model.startTimer()
    }
    
    @IBAction private func loginInfoButtonTouchUp(_ sender: UIButton) {
        model.loginInfoButtonPublisher.send(())
    }
}
