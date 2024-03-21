//
//  SwordPeer.swift
//  SwordAppArch
//
//  Created by Tigran Simonyan on 17.08.23.
//

import Foundation
import TelegramApi

public final class SwordPeer {
    public init(peerId: Int, extraPeerId: Int, accessHash: String? = nil, title: String? = nil, inputPeerEmpty: Api.InputPeer, amount: Double? = nil) {
        self.peerId = peerId
        self.extraPeerId = extraPeerId
        self.accessHash = accessHash
        self.title = title
        self.inputPeerEmpty = inputPeerEmpty
        self.amount = amount
    }

    let peerId: Int
    let extraPeerId: Int
    let accessHash: String?
    let title: String?
    let inputPeerEmpty: Api.InputPeer
    var amount: Double?

    var toJson: [String: Any] {
        var mainInfo: [String: Any] = ["peerId": peerId,
                                       "extraPeerId": extraPeerId,
                                       "type": inputPeerEmpty.descriptionFields().0]
        
        if let accessHash = accessHash {
            mainInfo["accessHash"] = accessHash
        }
        
        if let title = title {
            mainInfo["title"] = title
        }
        
        if let amount {
            mainInfo["amount"] = amount
        }
        
        return mainInfo
    }
}

public struct TelegramPeer: Codable {
    let peerId: String
    let accessHash: String?
    let title: String?
}
