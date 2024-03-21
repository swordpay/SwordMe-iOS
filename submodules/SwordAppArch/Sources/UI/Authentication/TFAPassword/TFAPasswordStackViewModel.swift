//
//  TFAPasswordStackViewModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 11.08.23.
//

import Combine
import Foundation

public final class TFAPasswordStackViewModel {
    lazy var passwordTextFieldModel: ValidatableTextFieldModel = {
        let hint: String = {
            guard let passwordHint, !passwordHint.isEmpty else {
                return "Password"
            }
            
            return passwordHint
        }()

        let model = ValidatableTextFieldModel(text: "",
                                              placeholder: hint,
                                              isEditable: true,
                                              keyboardType: .default,
                                              returnKeyType: .done,
                                              validator: RequiredFieldValidator(minLenght: 2, maxLenght: 200),
                                              isSecureTextEntryEnabled: true)

        return model
    }()

    let forgotPasswordButtonHandler: PassthroughSubject<Void, Never> = .init()
    let resetAccountButtonHandler: PassthroughSubject<Void, Never> = .init()

    private var passwordHint: String?
    var state: State
    
    init(passwordHint: String?, state: State) {
        self.passwordHint = passwordHint
        self.state = state
    }
}

public extension TFAPasswordStackViewModel {
    enum State {
        case forgotPassword
        case resetAccount
        case authorization
    }
}
