//
//  UserFirstNameValidator.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 01.06.22.
//

import Foundation

struct UserUsernameValidator: TextValidating {
    func validate(_ text: String?) -> Constants.Typealias.TextValidationResult {
        guard let text = text,
              !text.trimmingCharacters(in: .whitespaces).isEmpty else {
            return (.failure(Constants.Localization.ValidationMessage.emptyUserName), nil)
        }

        let textWithoutWhitspaces = text.trimmingCharacters(in: .whitespaces)
        let acceptableLenght = (2...38)
        let hasAcceptableLenght = acceptableLenght.contains(textWithoutWhitspaces.count)

        guard hasAcceptableLenght else {
            return (.failure(Constants.Localization.ValidationMessage.userNameCharectersLenght), textWithoutWhitspaces)
        }

        let usernameRegEx = "^[a-zA-Z\\d](?:[a-zA-Z\\d]|-(?=[a-zA-Z\\d])){0,38}$"
        let usernamePredicate = NSPredicate(format:"SELF MATCHES %@", usernameRegEx)
        
        guard usernamePredicate.evaluate(with: textWithoutWhitspaces) else {
            return (.failure(Constants.Localization.ValidationMessage.invalidUsername), textWithoutWhitspaces)
        }

        return (.success, textWithoutWhitspaces)
    }
}

extension UserNamesValidator {
    enum NameType {
        case firstName
        case lastName

        var errorMessage: String {
            switch self {
            case .firstName:
                return Constants.Localization.ValidationMessage.emptyFirstName
            case .lastName:
                return Constants.Localization.ValidationMessage.emptyLastName
            }
        }
    }
}

struct UserNamesValidator: TextValidating {
    let nameType: NameType
    
    init(nameType: NameType) {
        self.nameType = nameType
    }

    func validate(_ text: String?) -> Constants.Typealias.TextValidationResult {
        guard let text = text,
              !text.trimmingCharacters(in: .whitespaces).isEmpty else {
            return (.failure(nameType.errorMessage), nil)
        }

        let textWithoutWhitspaces = text.trimmingCharacters(in: .whitespaces)
        let acceptableLenght = (2...40)
        let hasAcceptableLenght = acceptableLenght.contains(textWithoutWhitspaces.count)

        guard hasAcceptableLenght else {
            return (.failure(Constants.Localization.ValidationMessage.userNamesLenght), textWithoutWhitspaces)
        }

        let usernameRegEx = "^[a-zA-Z]+(([' -][a-zA-Z ])?[a-zA-Z]*)"
        let usernamePredicate = NSPredicate(format:"SELF MATCHES %@", usernameRegEx)

        guard usernamePredicate.evaluate(with: textWithoutWhitspaces) else {
            return (.failure(Constants.Localization.ValidationMessage.invalidName), textWithoutWhitspaces)
        }

        return (.success, textWithoutWhitspaces)
    }
}
