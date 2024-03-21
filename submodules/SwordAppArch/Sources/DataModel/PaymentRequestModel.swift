//
//  PaymentRequestModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 28.12.22.
//

import UIKit

public struct PaymentRequestModel {
    let messageId: Int
    let sentFrom: MessageParticipant
    let isSentByMe: Bool
    let sentTo: [MessageParticipant]
    let date: String
    let amount: Double
    let paymentInfo: [PaymentInfo]
    
}

extension PaymentRequestModel {
    public struct PaymentInfo {
        let sender: MessageParticipant
        let amount: Double
        let paymentMethodType: PaymentMethodTypeModel
        let date: String
    }
}
