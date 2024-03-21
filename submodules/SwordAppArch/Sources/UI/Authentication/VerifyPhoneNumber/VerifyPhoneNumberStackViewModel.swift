//
//  VerifyPhoneNumberStackViewModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 07.12.22.
//

import Combine
import Foundation

public final class VerifyPhoneNumberStackViewModel {
    private var cancellables: Set<AnyCancellable> = []
    private var remainingTime = 15

    let phoneNumber: String
    let isLoginInfoNeeded: Bool
    let verificationReason: PhoneNumberVerificationReason

    let verificationCodePublisher: PassthroughSubject<String, Never> = PassthroughSubject()
    let resendButtonPublisher: PassthroughSubject<Void, Never> = PassthroughSubject()
    let loginInfoButtonPublisher: PassthroughSubject<Void, Never> = PassthroughSubject()
    
    /// Timer
    var expirationTimer: Timer?
    var timerText: CurrentValueSubject<String, Never> = CurrentValueSubject("00:15")
    var canResendCode: CurrentValueSubject<Bool, Never> = CurrentValueSubject(false)

    lazy var verificationCodeViewModel: CodeVerificationViewModel = {
        let model = CodeVerificationViewModel(validCodeLenght: 5)
        
        model.areAllNumbersFilled
            .sink { [ weak self ] isCodeReady in
                guard isCodeReady else { return }
                
                let verificationCode = model.filledNumbers.joined()
                
                print("Code is \(verificationCode)")
                self?.verificationCodePublisher.send(verificationCode)
            }
            .store(in: &cancellables)
        
        return model
    }()

    var title: String {
        return isLoginInfoNeeded ? "Open you're Telegram App to receive your Sword Access Code."
                                 : "For added security. Open your Telegram App to receive your final Sword Access code."
//        let isEmail = phoneNumber.contains("@")
//        let lastFourNumbers = String(phoneNumber.suffix(4))
//
//        let contactInfo: String
//        if isEmail {
//            let components = phoneNumber.components(separatedBy: "@")
//
//            guard components.count == 2 else {
//                return Constants.Localization.Authentication.verifyPhoneNumberMainTitle.localized(with: [phoneNumber])
//            }
//
//            if components[0].count < 2 {
//                contactInfo = "***@\(components[1])"
//            } else {
//                contactInfo = "***\(components[0].suffix(2))@\(components[1])"
//            }
//        } else {
//            contactInfo = "***\(lastFourNumbers)"
//        }
//
//        return Constants.Localization.Authentication.verifyPhoneNumberMainTitle.localized(with: [contactInfo])
    }

    var descriptionText: String {
        return Constants.Localization.Authentication.verifyPhoneNumberDescription.localized
    }

    public init(phoneNumber: String, isLoginInfoNeeded: Bool, verificationReason: PhoneNumberVerificationReason) {
        self.phoneNumber = phoneNumber
        self.isLoginInfoNeeded = isLoginInfoNeeded
        self.verificationReason = verificationReason
    }
    
    func startTimer() {
        remainingTime = 15
        timerText.send("00:15")

        expirationTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [ weak self ] timer in
            guard let self else { return }

            self.remainingTime -= 1
            let remainingTimeText = self.remainingTime < 10 ? "0\(self.remainingTime)" : "\(self.remainingTime)"

            self.timerText.send("00:\(remainingTimeText)")
            self.stopTimerIfNeeded(remainingTime: self.remainingTime)
        })
    }
    
    private func stopTimerIfNeeded(remainingTime: Int) {
        guard remainingTime == 0 else { return }
        
        expirationTimer?.invalidate()
        expirationTimer = nil
     
        canResendCode.send(true)
    }
}
