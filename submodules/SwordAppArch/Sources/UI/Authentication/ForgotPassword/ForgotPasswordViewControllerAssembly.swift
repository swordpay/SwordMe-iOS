//
//  ForgotPasswordViewControllerAssembly.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 25.01.23.
//

import Swinject
import Foundation

final class ForgotPasswordViewControllerAssembly: Assembly {
    func assemble(container: Container) {
        container.register(ForgotPasswordViewModel.self) { resolver in
            let forgotPasswordService = resolver.resolve(ForgotPasswordServicing.self)!
            let inputs = ForgotPasswordViewModelInputs(forgotPasswordService: forgotPasswordService)
            let viewModel = ForgotPasswordViewModel(inputs: inputs)
            
            return viewModel
        }
     
        container.register(ForgotPasswordViewController.self) { resolver in
            let viewModel = resolver.resolve(ForgotPasswordViewModel.self)!
            let viewController = ForgotPasswordViewController()
            
            viewController.viewModel = viewModel
            
            return viewController
        }
    }
}
