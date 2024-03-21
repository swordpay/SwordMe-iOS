//
//  TitledValidatableTextFieldModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 14.02.23.
//

import Foundation

final class TitledValidatableTextFieldModel {
    let title: String
    let textFieldModel: ValidatableTextFieldModel
    
    init(title: String, textFieldModel: ValidatableTextFieldModel) {
        self.title = title
        self.textFieldModel = textFieldModel
    }
}
