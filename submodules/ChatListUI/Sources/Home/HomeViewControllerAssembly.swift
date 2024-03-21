//
//  HomeViewControllerAssembly.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 04.05.23.
//

import Swinject
import Foundation
import SwordAppArch
import AccountContext

final class HomeViewControllerAssembly: Assembly {
    let context: AccountContext

    init(context: AccountContext) {
        self.context = context
    }
    
    func assemble(container: Container) {
        let context = context
        
        container.register(HomeViewModel.self) { resolver in
            let getUserByUsernameService = resolver.resolve(GetUserByUsernameServicing.self)!
            let verifyEmailTokenService = resolver.resolve(VerifyEmailTokenServicing.self)!
            let getUserService = resolver.resolve(GetUserServicing.self)!

            let inputs = HomeViewModelInputs(getUserService: getUserService,
                                             getUserByUsernameService: getUserByUsernameService,
                                             verifyEmailTokenService: verifyEmailTokenService)

            return HomeViewModel(inputs: inputs)
        }

        container.register(HomeViewController.self) { resolver in
            let viewModel = resolver.resolve(HomeViewModel.self)!
            let viewController = HomeViewController(viewModel: viewModel, context: context)

            return viewController
        }
    }
}
