//
//  ChannelParticipantsListViewControllerAssembly.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 22.05.23.
//

import Swinject
import Foundation

final class ChannelParticipantsListViewControllerAssembly: Assembly {
    let participants: [Constants.Typealias.PeerExtendedInfo]
    
    init(participants: [Constants.Typealias.PeerExtendedInfo]) {
        self.participants = participants
    }

    func assemble(container: Container) {
        let participants = self.participants
        container.register(ChannelParticipantsListViewModel.self) { resolver in
            return ChannelParticipantsListViewModel(participants: participants)
        }

        container.register(ChannelParticipantsListViewController.self) { resolver in
            let viewModel = resolver.resolve(ChannelParticipantsListViewModel.self)!
            let viewController = ChannelParticipantsListViewController(viewModel: viewModel)
            
            return viewController
        }
    }
}
