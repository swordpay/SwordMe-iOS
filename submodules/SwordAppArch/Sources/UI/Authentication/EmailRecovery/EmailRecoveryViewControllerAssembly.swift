//
//  EmailRecoveryViewControllerAssembly.swift
//  SwordAppArch
//
//  Created by Tigran Simonyan on 11.08.23.
//

import Swinject
import Foundation
import TelegramCore

final class EmailRecoveryViewControllerAssembly: Assembly {
    
    var email: String
    
    init(email: String) {
        self.email = email
    }

    func assemble(container: Container) {
        let email = self.email

        container.register(EmailRecoveryViewModel.self) { resolver in
            let viewModel = EmailRecoveryViewModel(email: email)

            return viewModel
        }
     
        container.register(EmailRecoveryViewController.self) { resolver in
            let viewModel = resolver.resolve(EmailRecoveryViewModel.self)!
            let viewController = EmailRecoveryViewController(viewModel: viewModel)
            
            return viewController
        }
    }
}
