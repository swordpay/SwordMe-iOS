//
//  PhoneNumberViewController.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 07.12.22.
//

import UIKit
import Display
import TelegramCore
import PhoneNumberFormat

public final class PhoneNumberViewController: GenericStackViewController<PhoneNumberViewModel, PhoneNumberStackView> {
    public override var shouldEmbedInScrollView: Bool { return true }
    
    // MARK: - Lifecycle Methods
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
//        title = viewModel.navigationTitle
    }

    // MARK: - Binding
    
    public override func bindViewModel() {
        super.bindViewModel()
        
        bindToPhoneNumberPublisher()
    }
    
    private func bindToPhoneNumberPublisher() {
        viewModel.phoneNumberPublisher
            .sink { [ weak self ] phoneNumber in
                self?.continuePressed(phoneNumber: phoneNumber)
            }
            .store(in: &cancellables)
    }
        
    // TODO: - This can be removed

    private func goToVerifyPhoneNumber(phoneNumber: String) {
        view.endEditing(true)

        viewModel.setupModel.value?.phoneNumberTextFieldModel.makeFirstResponderPublisher.send(false)
        navigator.goTo(PhoneNumberDestination.verifyCode(phoneNumber,
                                                         verificationReason: viewModel.verificationReason,
                                                         destination: .back))
    }
        
    @objc func continuePressed(phoneNumber: String) {
        AppData.userPhoneNumber = phoneNumber
        viewModel.loginWithNumber?(phoneNumber, true)
    }
}
