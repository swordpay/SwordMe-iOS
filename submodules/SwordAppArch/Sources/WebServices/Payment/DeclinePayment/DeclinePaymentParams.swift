//
//  DeclinePaymentParams.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 31.03.23.
//

import Foundation

public struct DeclinePaymentParams: Routing {
    let paymentId: String
    let peer: SwordPeer
    let messageId: Int32
    
    public init(paymentId: String, peer: SwordPeer, messageId: Int32) {
        self.paymentId = paymentId
        self.peer = peer
        self.messageId = messageId
    }

    public var key: APIRepresentable {
        return Constants.PaymentsAPI.declinePayment(paymentId: paymentId)
    }
    
    public var params: [String : Any] {
        return ["peer": peer.toJson,
                "messageId": messageId]
    }
}
