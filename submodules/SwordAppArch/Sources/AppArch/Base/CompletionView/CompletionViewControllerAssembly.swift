//
//  CompletionViewControllerAssembly.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 27.06.22.
//

import Swinject
import Foundation

final class CompletionViewControllerAssembly: Assembly {
    let stackModel: CompletionStackViewModel
    let dismissAction: Constants.Typealias.VoidHandler?

    init(stackModel: CompletionStackViewModel,
         dismissAction: Constants.Typealias.VoidHandler?) {
        self.stackModel = stackModel
        self.dismissAction = dismissAction
    }

    func assemble(container: Container) {
        let stackModel = stackModel
        let dismissAction = dismissAction

        container.register(CompletionViewModel.self) { _ in
            return CompletionViewModel(stackModel: stackModel, dismissAction: dismissAction)
        }

        container.register(CompletionViewController.self) { resolver in
            let viewModel = resolver.resolve(CompletionViewModel.self)!
            let viewController = CompletionViewController()

            viewController.viewModel = viewModel

            return viewController
        }
    }
}
