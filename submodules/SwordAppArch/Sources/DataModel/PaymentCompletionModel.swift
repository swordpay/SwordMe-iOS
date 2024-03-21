//
//  PaymentCompletionModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 28.12.22.
//

import Foundation

struct PaymentCompletionModel {
    let paymentMethodTypeInfo: PaymentMethodTypeModel
    let paymentMethodType: PaymentMethodType
    let amount: Double
    let participants: [MessageParticipant]
    let note: String?
    let isRequesting: Bool
}
