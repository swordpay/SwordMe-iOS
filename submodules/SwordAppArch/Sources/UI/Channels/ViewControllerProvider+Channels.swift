//
//  ViewControllerProvider+Channels.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 20.12.22.
//

import Combine
import Postbox
import Swinject
import Foundation
import AccountContext

public extension ViewControllerProvider {
    enum Channels {
        static var channels: ChannelsViewController {
            let assembler = Assembler([ DataCacherAssembly(),
                                        URLSessionDataDownloaderAssembly(),
                                        DataDownloadManagerAssembly(),
                                        GetUserServiceAssembly(),
                                        GetChannelsServiceAssembly(),
                                        GetUserByUsernameServiceAssembly(),
                                        DeleteChannelServiceAssembly(),
                                        ChannelsViewControllerAssembly() ])
            let controller = assembler.resolver.resolve(ChannelsViewController.self)!

            return controller
        }
        
        static func channelParticipantPicker(isForMultipleSelecton: Bool,
                                             source: ChannelParticipantsPickerSource, context: AccountContext,
                                             mainPeer: Constants.Typealias.PeerExtendedInfo,
                                             addedPeers: [Constants.Typealias.PeerExtendedInfo]) -> ChannelParticipantsPickerViewController {
            let assembler = Assembler([ GetAllUsersServiceAssembly(),
                                        CreateChannelServiceAssembly(),
                                        GetLatestPaymentsServiceAssembly(),
                                        ChannelParticipantsPickerViewControllerAssembly(isForMultipleSelection: isForMultipleSelecton,
                                                                                        source: source,
                                                                                        context: context,
                                                                                        mainPeer: mainPeer,
                                                                                        addedPeers: addedPeers) ])
            let controller = assembler.resolver.resolve(ChannelParticipantsPickerViewController.self)!

            return controller
        }
        
        
        public static func channelPayment(stateInfo: PayOrRequestStateInfoModel, context: AccountContext) -> ChannelPaymentViewController {
            let assembler = Assembler([ DataCacherAssembly(),
                                        URLSessionDataDownloaderAssembly(),
                                        DataDownloadManagerAssembly(),
                                        MakePaymentServiceAssembly(),
                                        AccountsBalanceServiceAssembly(),
                                        GetCryptoAssetsServiceAssembly(),
                                        AssetsPricesChangesServiceAssembly(),
                                        ChannelPaymentViewControllerAssembly(stateInfo: stateInfo, context: context)])
            let controller = assembler.resolver.resolve(ChannelPaymentViewController.self)!

            return controller
        }
        
        static func channelRequestDetails(_ requestDetails: PaymentRequestModel,
                                          isForRequestDetails: Bool,
                                          closeRequestCompletion: PassthroughSubject<(Int, String?), Never>) -> ChannelRequestDetailsViewController {
            let assembler = Assembler([ChannelRequestDetailsViewControllerAssembly(requestDetails: requestDetails,
                                                                                   isForRequestDetails: isForRequestDetails,
                                                                                   closeRequestCompletion: closeRequestCompletion)])
            let controller = assembler.resolver.resolve(ChannelRequestDetailsViewController.self)!

            return controller

        }
        
        static var inviteFriends: InviteFriendsViewController {
            let assembler = Assembler([ SyncContactsServiceAssembly(),
                                        InviteFriendsViewControllerAssembly() ])
            let controller = assembler.resolver.resolve(InviteFriendsViewController.self)!

            return controller
        }
        
        static func channelParticipants(_ participants: [Constants.Typealias.PeerExtendedInfo]) -> ChannelParticipantsListViewController {
            let assembler = Assembler([ChannelParticipantsListViewControllerAssembly(participants: participants)])
            let controller = assembler.resolver.resolve(ChannelParticipantsListViewController.self)!

            return controller
        }
                
        static func topUp(paymentMethodType: PaymentMethodType) -> TopUpViewController {
            let assembler = Assembler([ TopUpViewControllerAssembly(paymentMethodType: paymentMethodType) ])
            let controller = assembler.resolver.resolve(TopUpViewController.self)!

            return controller
        }
    }
}
