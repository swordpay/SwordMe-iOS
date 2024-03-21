//
//  ChannelsDestination.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 20.12.22.
//

import UIKit
import Combine
import Postbox
import AccountContext

final class ChannelsDestinationProvider {
    private static var cachedController: [Int: UIViewController] = [:]
    
    static func viewController(for destination: ChannelsDestination) -> UIViewController {
        if let cachedController = cachedController[destination.id] {
            return cachedController
        }

        let controller: UIViewController
        switch destination {
        case .participantPicker(let isForMultipleSelection, let source, let context, let mainPeer, let addedPeers):
            let viewController = ViewControllerProvider.Channels.channelParticipantPicker(isForMultipleSelecton: isForMultipleSelection,
                                                                                          source: source,
                                                                                          context: context!,
                                                                                          mainPeer: mainPeer!,
                                                                                          addedPeers: addedPeers)
            controller = viewController
        case .channelPayment:
            controller = UIViewController()
        case .channelRequestDetails(let requestDetails, let isForRequestDetails, let closeRequestCompletion):
            controller = ViewControllerProvider.Channels.channelRequestDetails(requestDetails,
                                                                         isForRequestDetails: isForRequestDetails,
                                                                          closeRequestCompletion: closeRequestCompletion)
        case .inviteFriends:
            controller = ViewControllerProvider.Channels.inviteFriends
        case .channelParticipantsList(let participants):
            controller = ViewControllerProvider.Channels.channelParticipants(participants)
        }
        
        cachedController[destination.id] = controller
        
        return controller
    }
    
    static func removeCachedViewControlelrs(for destination: ChannelsDestination) {
        cachedController.removeValue(forKey: destination.id)
    }
}

public enum ChannelsDestination: Destinationing {
    case participantPicker(Bool, source: ChannelParticipantsPickerSource, context: AccountContext?, mainPeer: Constants.Typealias.PeerExtendedInfo?, addedPeers: [Constants.Typealias.PeerExtendedInfo])
    case channelPayment(stateInfo: PayOrRequestStateInfoModel)
    case channelRequestDetails(PaymentRequestModel, Bool, PassthroughSubject<(Int, String?), Never>)
    case inviteFriends
    case channelParticipantsList(_ participants: [Constants.Typealias.PeerExtendedInfo])
    
    var id: Int {
        switch self {
        case .participantPicker:
            return 0
        case .channelPayment:
            return 1
        case .channelRequestDetails:
            return 2
        case .inviteFriends:
            return 3
        case .channelParticipantsList:
            return 4
        }
    }
    
    public var viewController: UIViewController {
        return ChannelsDestinationProvider.viewController(for: self)
    }

    public var navigationType: NavigationType {
        switch self {
        case .channelPayment, .participantPicker:
            return .modal(presentationMode: .pageSheet)
        default:
            return .push(animated: true)
        }
    }
}
