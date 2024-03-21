//
//  MakePaymentParams.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 31.03.23.
//

import UIKit

struct MakePaymentParams: MakePaymentRouting {
    let currencyType: String
    let paymentType: PaymentType
    let paymentMethodType: PaymentMethodType
    
    let amountType: AmountType?

    let note: String?
    let peers: [SwordPeer]
    let referenceId: String = UUID().uuidString
    
    init(currencyType: String,
         paymentType: PaymentType,
         paymentMethodType: PaymentMethodType,
         amountType: AmountType?,
         peers: [SwordPeer],
         note: String? = nil) {
        self.currencyType = currencyType
        self.paymentType = paymentType
        self.paymentMethodType = paymentMethodType
        self.amountType = amountType
        self.note = note
        self.peers = peers
    }

    var key: APIRepresentable {
        return Constants.PaymentsAPI.makePayment
    }
    
    var params: [String : Any] {
        var mainParams: [String : Any] = [
            "transactionType": paymentMethodType.rawValue,
            "type": paymentType.rawValue,
            "currencyType": currencyType,
            "note": (note ?? "").trimmingCharacters(in: .whitespacesAndNewlines),
            "referenceId": referenceId,
            "peers": peers.map { $0.toJson }
        ]
        
        if let amountType {
            mainParams["amountType"] = amountType.rawValue
        }
        
        return mainParams
    }
}
