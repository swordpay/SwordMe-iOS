//
//  ChannelsViewControllerAssembly.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 20.12.22.
//

import Swinject
import Foundation

final class ChannelsViewControllerAssembly: Assembly {
    func assemble(container: Container) {
        container.register(ChannelsViewModel.self) { resolver in
            let downloadManager = resolver.resolve(DataDownloadManaging.self)!
            let getUserSrevice = resolver.resolve(GetUserServicing.self)!
            let getChannelsService = resolver.resolve(GetChannelsServicing.self)!
            let getUserByUsernameService = resolver.resolve(GetUserByUsernameServicing.self)!
            let deleteChannelService = resolver.resolve(DeleteChannelServicing.self)!
            
            let inputs = ChannelsViewModelInputs(downloadManager: downloadManager,
                                                 getUserService: getUserSrevice,
                                                 getChannelsService: getChannelsService,
                                                 getUserByUsernameService: getUserByUsernameService,
                                                 deleteChannelService: deleteChannelService)

            return ChannelsViewModel(inputs: inputs)
        }

        container.register(ChannelsViewController.self) { resolver in
            let viewModel = resolver.resolve(ChannelsViewModel.self)!
            let viewController = ChannelsViewController()

            viewController.viewModel = viewModel

            return viewController
        }
    }
}
