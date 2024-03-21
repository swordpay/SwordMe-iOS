//
//  VerifyPhoneNumberViewModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 07.12.22.
//

import UIKit
import Combine

public struct VerifyPhoneNumberViewModelInputs {
    let verifyPhoneNumberService: VerifyPhoneNumberServicing
    let phoneNumberService: PhoneNumberServicing
    let resendVerificationCodeService: ResendVerificationCodeServicing
}

public final class VerifyPhoneNumberViewModel: BaseViewModel<VerifyPhoneNumberViewModelInputs>, StackViewModeling {
    public var setupModel: CurrentValueSubject<VerifyPhoneNumberStackViewModel?, Never>

    public override var shouldBindToAuthorizationManagerLoading: Bool { return true }
    var destination: VerifyPhoneNumberDestination
    let verificationReason: PhoneNumberVerificationReason
    
    var codeVerificationCompletion: PassthroughSubject<Void, Never> = PassthroughSubject()

    var navigationTitle: String? {
        switch verificationReason {
        case .registration, .verification:
            return nil
        case .twoFactorAuthentication, .changePassword:
            return Constants.Localization.Profile.textMessage
        }
    }

    public var loginWithCode: ((String) -> Void)?
    public var back: (() -> Void)?
    public var requestNextOption: (() -> Void)?
    public var loginInfo: (() -> Void)?

    init(inputs: VerifyPhoneNumberViewModelInputs,
         phoneNumber: String,
         isLoginInfoNeeded: Bool,
         verificationReason: PhoneNumberVerificationReason,
         destination: VerifyPhoneNumberDestination,
         loginWithCode: ((String) -> Void)?,
         requestNextOption: (() -> Void)?,
         back: (() -> Void)?) {
        let setupModel = VerifyPhoneNumberStackViewModel(phoneNumber: phoneNumber,
                                                         isLoginInfoNeeded: isLoginInfoNeeded,
                                                         verificationReason: verificationReason)
        self.setupModel = CurrentValueSubject(setupModel)
        self.verificationReason = verificationReason
        self.destination = destination
        self.loginWithCode = loginWithCode
        self.requestNextOption = requestNextOption
        self.back = back
        
        super.init(inputs: inputs)
        
        bindToVerificationCode()
        bindToResendButtonPublisher()
        bindToLoginInfoButtonPublisher()
    }

    // MARK: - Binding
    
    private func bindToVerificationCode() {
        setupModel.value?.verificationCodePublisher
            .sink { [ weak self ] code in
                self?.loginWithCode?(code)
            }
            .store(in: &cancellables)
    }

    private func bindToResendButtonPublisher() {
        setupModel.value?.resendButtonPublisher
            .sink { [ weak self ] in
                self?.resendCode()
            }
            .store(in: &cancellables)
    }

    private func bindToLoginInfoButtonPublisher() {
        setupModel.value?.loginInfoButtonPublisher
            .sink { [ weak self ] in
                self?.loginInfo?()
            }
            .store(in: &cancellables)
    }

    // MARK: - Verification code

    private func verifyCode(_ code: String) {
    }
    
    private func resendCode() {
        requestNextOption?()
    }
    
    private func askNotificaitonPermissionIfNeeded() {
        guard case .tabBar = destination else { return }
        
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            if settings.authorizationStatus == .notDetermined {
                NotificationManagerProvider.native.registerForPushNotifications()
            }
        }
    }
}
