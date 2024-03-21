//
//  ResetPasswordViewControllerAssembly.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 26.01.23.
//

import Swinject
import Foundation

final class ResetPasswordViewControllerAssembly: Assembly {
    func assemble(container: Container) {
        container.register(ResetPasswordViewModel.self) { resolver in
            let resetPasswordService = resolver.resolve(ResetPasswordServicing.self)!
            let inputs = ResetPasswordViewModelInputs(resetPasswordService: resetPasswordService)
            let viewModel = ResetPasswordViewModel(inputs: inputs)
            
            return viewModel
        }
     
        container.register(ResetPasswordViewController.self) { resolver in
            let viewModel = resolver.resolve(ResetPasswordViewModel.self)!
            let viewController = ResetPasswordViewController(viewModel: viewModel)
            
            return viewController
        }
    }
}
