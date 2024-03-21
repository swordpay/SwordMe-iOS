//
//  EmailValidatorAssembly.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 01.06.22.
//

import Foundation
import Swinject

final class EmailValidatorAssembly: Assembly {
    func assemble(container: Container) {
        container.register(TextValidating.self) { _ in
            return EmailValidator()
        }
    }
}
