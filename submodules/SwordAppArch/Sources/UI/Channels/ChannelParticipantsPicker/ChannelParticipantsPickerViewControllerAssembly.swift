//
//  ChannelParticipantsPickerViewControllerAssembly.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 21.12.22.
//

import Swinject
import Foundation
import AccountContext

final class ChannelParticipantsPickerViewControllerAssembly: Assembly {
    let isForMultipleSelection: Bool
    let source: ChannelParticipantsPickerSource
    let context: AccountContext
    let mainPeer: Constants.Typealias.PeerExtendedInfo
    let addedPeers: [Constants.Typealias.PeerExtendedInfo]
    
    init(isForMultipleSelection: Bool,
         source: ChannelParticipantsPickerSource,
         context: AccountContext,
         mainPeer: Constants.Typealias.PeerExtendedInfo,
         addedPeers: [Constants.Typealias.PeerExtendedInfo]) {
        self.isForMultipleSelection = isForMultipleSelection
        self.source = source
        self.context = context
        self.mainPeer = mainPeer
        self.addedPeers = addedPeers
    }

    func assemble(container: Container) {
        let isForMultipleSelection = self.isForMultipleSelection
        let source = source
        let context = context
        let mainPeer = mainPeer
        let addedPeers = addedPeers

        container.register(ChannelParticipantsPickerViewModel.self) { resolver in
            let createChannelService = resolver.resolve(CreateChannelServicing.self)!
            let getAllUsersService = resolver.resolve(GetAllUsersServicing.self)!
            let getLatestPaymentsService = resolver.resolve(GetLatestPaymentsServicing.self)!

            let inputs = ChannelParticipantsPickerViewModelInputs(createChannelService: createChannelService,
                                                                  getAllUsersService: getAllUsersService,
                                                                  getLatestPaymentsService: getLatestPaymentsService)
            
            return ChannelParticipantsPickerViewModel(inputs: inputs,
                                                      accountContext: context,
                                                      isForMultipleSelection: isForMultipleSelection,
                                                      source: source,
                                                      mainPeer: mainPeer,
                                                      addedPeers: addedPeers)
        }

        container.register(ChannelParticipantsPickerViewController.self) { resolver in
            let viewModel = resolver.resolve(ChannelParticipantsPickerViewModel.self)!
            let viewController = ChannelParticipantsPickerViewController(viewModel: viewModel)
            
            viewController.hidesBottomBarWhenPushed = true

            return viewController
        }
    }
}
