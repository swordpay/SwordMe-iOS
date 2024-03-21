//
//  SystemServiceCameraScreenViewControllerAssembly.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 20.04.22.
//

import Foundation
import Swinject

final class SystemServiceCameraScreenViewControllerAssembly: Assembly {
    let shouldDismissBeforeCompletion: Bool
    let requestCompletion: Constants.Typealias.SystemServiceRequestCompletionHandler?

    init(shouldDismissBeforeCompletion: Bool = true,
         requestCompletion: Constants.Typealias.SystemServiceRequestCompletionHandler? = nil) {
        self.shouldDismissBeforeCompletion = shouldDismissBeforeCompletion
        self.requestCompletion = requestCompletion
    }

    func assemble(container: Container) {
        let shouldDismissBeforeCompletion = self.shouldDismissBeforeCompletion
        let requestCompletion = self.requestCompletion

        container.register(ActionableSystemServiceViewModel.self) { resolver in
            let model = resolver.resolve(SystemServicePresentationModel.self)!
            let viewModel = ActionableSystemServiceViewModel(systemServiceInfo: model)

            viewModel.shouldDismissBeforeCompletion = shouldDismissBeforeCompletion
            viewModel.requestCompletion = requestCompletion

            return viewModel
        }

        container.register(SystemServiceCameraViewController.self) { resolver in
            let viewModel = resolver.resolve(ActionableSystemServiceViewModel.self)!
            let viewController = SystemServiceCameraViewController()

            viewController.viewModel = viewModel

            return viewController
        }
    }
}
