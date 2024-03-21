//
//  AcceptPaymentParams.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 19.04.23.
//

import Foundation

struct AcceptPaymentParams: MakePaymentRouting {
    let paymentId: String

    let amount: Double?
    let currencyType: String
    let paymentMethodType: PaymentMethodType
    let note: String?
    let messageId: Int32
    let peer: SwordPeer
    
    var key: APIRepresentable {
        return Constants.PaymentsAPI.acceptPayment(paymentId: paymentId)
    }
    
    var params: [String : Any] {
        var mainParams: [String: Any] = [
            "transactionType": paymentMethodType.rawValue,
            "currencyType": currencyType,
            "note": (note ?? "").trimmingCharacters(in: .whitespacesAndNewlines),
            "peer": peer.toJson,
            "messageId": messageId
        ]
            
        if let amount {
            mainParams["amount"] = amount
        }

        return mainParams
    }
}
