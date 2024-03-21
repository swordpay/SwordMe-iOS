//
//  SystemServiceScreenViewControllerAssembly.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 18.04.22.
//

import Foundation
import Swinject

final class SystemServiceScreenViewControllerAssembly: Assembly {
    func assemble(container: Container) {
        container.register(SystemServiceViewModel.self) { resolver in
            let model = resolver.resolve(SystemServicePresentationModel.self)!
            let viewModel = SystemServiceViewModel(systemServiceInfo: model)

            return viewModel
        }

        container.register(SystemServiceViewController.self) { resolver in
            let viewModel = resolver.resolve(SystemServiceViewModel.self)!
            let viewController = SystemServiceViewController()

            viewController.viewModel = viewModel

            return viewController
        }
    }
}
