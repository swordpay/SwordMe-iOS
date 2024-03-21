//
//  PhoneNumberViewModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 07.12.22.
//

import Combine
import Foundation
import TelegramCore

public struct PhoneNumberViewModelInputs {
    let phoneNumberService: PhoneNumberServicing
}

public final class PhoneNumberViewModel: BaseViewModel<PhoneNumberViewModelInputs>, StackViewModeling {
    public var setupModel: CurrentValueSubject<PhoneNumberStackViewModel?, Never>
    
    let existedUserPublisher: PassthroughSubject<String, Never> = PassthroughSubject()
    let sendCodePublisher: PassthroughSubject<String, Never> = PassthroughSubject()
    let verificationReason: PhoneNumberVerificationReason
    
    let phoneNumberPublisher: PassthroughSubject<String, Never> = .init()
    
    let otherAccountPhoneNumbers: ((String, AccountRecordId, Bool)?, [(String, AccountRecordId, Bool)])
    public var loginWithNumber: ((String, Bool) -> Void)?

    var navigationTitle: String? {
        switch verificationReason {
        case .registration, .verification:
            return nil
        case .twoFactorAuthentication, .changePassword:
            return Constants.Localization.Profile.textMessage
        }
    }

    init(inputs: PhoneNumberViewModelInputs, verificationReason: PhoneNumberVerificationReason, otherAccountPhoneNumbers: ((String, AccountRecordId, Bool)?, [(String, AccountRecordId, Bool)]), loginWithNumber: ((String, Bool) -> Void)?) {
        let setupModel = PhoneNumberStackViewModel(verificationReason: verificationReason)
        self.setupModel = CurrentValueSubject(setupModel)
        self.verificationReason = verificationReason
        self.otherAccountPhoneNumbers = otherAccountPhoneNumbers
        self.loginWithNumber = loginWithNumber

        super.init(inputs: inputs)

        bindToSetupModelSendCodePublisher()
    }
    
    func prepareOnboardingUserInfoIfNeeded() {
        guard verificationReason == .registration else { return }

        var newUser = OnboardingUserModel()
        newUser.type = AppData.onboardingUser?.type
        newUser.phoneNumber = AppData.onboardingUser?.phoneNumber
        
        AppData.onboardingUser = newUser
    }
    
    private func bindToSetupModelSendCodePublisher() {
        setupModel.value?.sendCodeButtonPublisher
            .sink { [weak self] in
                
                guard let phoneNumber = self?.setupModel.value?.phoneNumberTextFieldModel.currentText else { return }

                self?.phoneNumberPublisher.send(phoneNumber)
            }
            .store(in: &cancellables)
    }

    private func storePhoneNumberIfNeeded() {
        guard verificationReason == .registration,
              let phoneNumber = setupModel.value?.phoneNumberTextFieldModel.currentText else { return }

        AppData.onboardingUser?.phoneNumber = phoneNumber
    }
}
