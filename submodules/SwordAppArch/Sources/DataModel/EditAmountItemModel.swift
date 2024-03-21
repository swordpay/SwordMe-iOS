//
//  EditAmountItemModel.swift
//  SwordAppArch
//
//  Created by Tigran Simonyan on 11.09.23.
//

import Foundation

public final class EditAmountItemModel: Hashable {
    let swordPeer: SwordPeer
    let userInfo: Constants.Typealias.PeerExtendedInfo
    
    public init(swordPeer: SwordPeer, userInfo: Constants.Typealias.PeerExtendedInfo) {
        self.swordPeer = swordPeer
        self.userInfo = userInfo
    }
    
    public static func == (lhs: EditAmountItemModel, rhs: EditAmountItemModel) -> Bool {
        return lhs.swordPeer.peerId == rhs.swordPeer.peerId
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(swordPeer.peerId)
    }
}
