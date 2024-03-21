//
//  ChannelsHeaderViewModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 04.05.23.
//

import Combine
import Foundation
import TelegramCore
import AccountContext
import TelegramPresentationData

public final class ChannelsHeaderViewModel {
    public let recentChannels: CurrentValueSubject<[Info], Never>
    
    public let selectedChannel: PassthroughSubject<Info, Never> = PassthroughSubject()

    public var isVisible: Bool {
        return !recentChannels.value.isEmpty
    }
    
    public init(recentChannels: [Info]) {
        self.recentChannels = .init(recentChannels)
    }
}

extension ChannelsHeaderViewModel {
    public struct Info {        
        public let enginePeer: EnginePeer
        public let account: Account?
        public let context: AccountContext
        public let theme: PresentationTheme
        public let synchronousLoads: Bool
        public let peerPresenceState: PeerPresenceState
        
        public init(enginePeer: EnginePeer, account: Account?, context: AccountContext, theme: PresentationTheme, synchronousLoads: Bool, peerPresenceState: PeerPresenceState) {
            self.enginePeer = enginePeer
            self.account = account
            self.context = context
            self.theme = theme
            self.synchronousLoads = synchronousLoads
            self.peerPresenceState = peerPresenceState
        }
    }
    
    public enum PeerPresenceState {
        case online
        case recently
    }
}
