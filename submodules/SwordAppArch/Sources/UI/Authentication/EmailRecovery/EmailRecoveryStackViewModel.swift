//
//  EmailRecoveryStackViewModel.swift
//  SwordAppArch
//
//  Created by Tigran Simonyan on 11.08.23.
//

import Combine
import Foundation

public final class EmailRecoveryStackViewModel {
    let email: String
    
    lazy var codeTextFieldModel: ValidatableTextFieldModel = {
        let model = ValidatableTextFieldModel(text: "",
                                              placeholder: Constants.Localization.Common.code,
                                              isEditable: true,
                                              keyboardType: .numberPad,
                                              returnKeyType: .next,
                                              validator: RequiredFieldValidator(minLenght: 2, maxLenght: 6),
                                              isSecureTextEntryEnabled: false)

        return model
    }()

    let cantAccessEmailButtonHandler: PassthroughSubject<Void, Never> = .init()
    let resendCodeButtonHandler: PassthroughSubject<Void, Never> = .init()

    init(email: String) {
        self.email = email
    }
}
