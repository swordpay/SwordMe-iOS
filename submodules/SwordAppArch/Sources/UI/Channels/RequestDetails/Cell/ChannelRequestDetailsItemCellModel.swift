//
//  ChannelRequestDetailsItemCellModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 28.12.22.
//

import Foundation

final class ChannelRequestDetailsItemCellModel {
    let paymentInfo: PaymentRequestModel.PaymentInfo
    
    var paymentAmountText: String {        
        return "\(paymentInfo.paymentMethodType.abbreviation) \(paymentInfo.amount)"
    }

    init(paymentInfo: PaymentRequestModel.PaymentInfo) {
        self.paymentInfo = paymentInfo
    }
}
