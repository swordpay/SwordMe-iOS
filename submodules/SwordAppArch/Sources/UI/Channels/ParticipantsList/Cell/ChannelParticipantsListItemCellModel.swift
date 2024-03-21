//
//  ChannelParticipantsListItemCellModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 22.05.23.
//

import Foundation
import Kingfisher

final class ChannelParticipantsListItemCellModel {
    let user: Constants.Typealias.PeerExtendedInfo
    

    init(user: Constants.Typealias.PeerExtendedInfo) {
        self.user = user
    }
}
