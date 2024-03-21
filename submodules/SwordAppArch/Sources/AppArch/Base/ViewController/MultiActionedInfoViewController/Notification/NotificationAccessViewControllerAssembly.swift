//
//  NotificationAccessViewControllerAssembly.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 27.01.23.
//

import Swinject
import Foundation

final class NotificationAccessViewControllerAssembly: Assembly {
    func assemble(container: Container) {
        container.register(NotificationAccessViewModel.self) { _ in
            return NotificationAccessViewModel(inputs: ())
        }
        
        container.register(NotificationAccessViewController.self) { resolver in
            let viewModel = resolver.resolve(NotificationAccessViewModel.self)!
            let viewController = NotificationAccessViewController()
            
            viewController.viewModel = viewModel
            
            return viewController
        }
    }
}
