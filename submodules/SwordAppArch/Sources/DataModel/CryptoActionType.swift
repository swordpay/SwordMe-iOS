//
//  CryptoActionType.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 09.03.23.
//

import Foundation

struct CryptoActionModel {
    let crypto: CryptoModel
    let action: CryptoActionType
    let amount: Double?
    let amountType: AmountType?
    
    internal init(crypto: CryptoModel, action: CryptoActionType, amount: Double? = nil, amountType: AmountType? = nil) {
        self.crypto = crypto
        self.action = action
        self.amount = amount
        self.amountType = amountType
    }
}

enum CryptoActionType: String {
    case buy
    case sell
}
