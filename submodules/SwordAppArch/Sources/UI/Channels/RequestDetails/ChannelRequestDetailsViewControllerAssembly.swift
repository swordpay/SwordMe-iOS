//
//  ChannelRequestDetailsViewControllerAssembly.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 28.12.22.
//

import Combine
import Swinject
import Foundation

final class ChannelRequestDetailsViewControllerAssembly: Assembly {
    let requestDetails: PaymentRequestModel
    let isForRequestDetails: Bool
    let closeRequestCompletion: PassthroughSubject<(Int, String?), Never>

    init(requestDetails: PaymentRequestModel,
         isForRequestDetails: Bool,
         closeRequestCompletion: PassthroughSubject<(Int, String?), Never>) {
        self.requestDetails = requestDetails
        self.isForRequestDetails = isForRequestDetails
        self.closeRequestCompletion = closeRequestCompletion
    }

    func assemble(container: Container) {
        let requestDetails = self.requestDetails
        let isForRequestDetails = self.isForRequestDetails
        let closeRequestCompletion = self.closeRequestCompletion
        
        container.register(ChannelRequestDetailsViewModel.self) { _ in
            return ChannelRequestDetailsViewModel(requestDetails: requestDetails,
                                                  isForRequestDetails: isForRequestDetails,
                                                  closeRequestCompletion: closeRequestCompletion)
        }

        container.register(ChannelRequestDetailsViewController.self) { resolver in
            let viewModel = resolver.resolve(ChannelRequestDetailsViewModel.self)!
            let viewController = ChannelRequestDetailsViewController()
            
            viewController.viewModel = viewModel
            
            return viewController
        }
    }
}
