//
//  TFAPasswordViewControllerAssembly.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 11.08.23.
//

import Swinject
import Foundation
import TelegramCore

final class TFAPasswordViewControllerAssembly: Assembly {
    
    var passwordHint: String
    var state: TFAPasswordStackViewModel.State
    
    init(passwordHint: String, state: TFAPasswordStackViewModel.State) {
        self.passwordHint = passwordHint
        self.state = state
    }

    func assemble(container: Container) {
        let passwordHint = self.passwordHint
        let state = self.state

        container.register(TFAPasswordViewModel.self) { resolver in
            let viewModel = TFAPasswordViewModel(passwordHint: passwordHint, state: state)

            return viewModel
        }
     
        container.register(TFAPasswordViewController.self) { resolver in
            let viewModel = resolver.resolve(TFAPasswordViewModel.self)!
            let viewController = TFAPasswordViewController(viewModel: viewModel)
            
            return viewController
        }
    }
}
