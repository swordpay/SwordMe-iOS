//
//  TopUpViewControllerAssembly.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 25.05.23.
//

import Swinject
import Foundation

final class TopUpViewControllerAssembly: Assembly {
    let paymentMethodType: PaymentMethodType
    
    init(paymentMethodType: PaymentMethodType) {
        self.paymentMethodType = paymentMethodType
    }

    func assemble(container: Container) {
        let paymentMethodType = self.paymentMethodType

        container.register(TopUpViewModel.self) { resolver in
            return TopUpViewModel(paymentMethodType: paymentMethodType)
        }

        container.register(TopUpViewController.self) { resolver in
            let viewModel = resolver.resolve(TopUpViewModel.self)!
            let viewController = TopUpViewController(viewModel: viewModel)
            
            return viewController
        }
    }
}
