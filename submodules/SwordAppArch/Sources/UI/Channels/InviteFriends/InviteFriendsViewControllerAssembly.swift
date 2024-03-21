//
//  InviteFriendsViewControllerAssembly.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 08.02.23.
//

import Swinject
import Foundation

final class InviteFriendsViewControllerAssembly: Assembly {
    func assemble(container: Container) {
        container.register(InviteFriendsViewModel.self) { resolver in
            let syncContactsService = resolver.resolve(SyncContactsServicing.self)!
            let inputs = InviteFriendsViewModelInputs(syncContactsService: syncContactsService)
            
            return InviteFriendsViewModel(inputs: inputs)
        }

        container.register(InviteFriendsViewController.self) { resolver in
            let viewModel = resolver.resolve(InviteFriendsViewModel.self)!
            let viewController = InviteFriendsViewController(viewModel: viewModel)
            
            return viewController
        }
    }
}
