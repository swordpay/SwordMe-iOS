//
//  BuyCryptoParams.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 20.03.23.
//

import Foundation

class BuyCryptoParams: Routing {
    let coin: String
    let amount: Double
    let currency: String
    let amountType: String

    init(coin: String, amount: Double, currency: String = "EUR", amountType: String, network: [String: String]? = nil,
         ramp: String? = nil, coinId: String? = nil, paymentMethod: String? = nil, quoteId: String? = nil) {
        self.coin = coin
        self.amount = amount
        self.currency = currency
        self.amountType = amountType
    }

    var key: APIRepresentable {
        return Constants.CryptoAPI.buyCrypto
    }

    var params: [String : Any] {
        return ["coin": coin,
                "amount": amount,
                "currency": currency,
                "amountType": amountType,
        ]
    }
}

final class OnrampBuyCryptoParams: BuyCryptoParams {
    let network: [String: String]
    let ramp: String
    let coinId: String
    let paymentMethod: String
    let quoteId: String

    init(coin: String, amount: Double, currency: String = "EUR", amountType: String = "fiat", network: [String: String],
         ramp: String, coinId: String, paymentMethod: String, quoteId: String) {
        self.network = network
        self.ramp = ramp
        self.coinId = coinId
        self.paymentMethod = paymentMethod
        self.quoteId = quoteId

        super.init(coin: coin, amount: amount, currency: currency, amountType: amountType)
    }
    
    override var params: [String : Any] {
        var mainParams = super.params

        mainParams["network"] = network
        mainParams["ramp"] = ramp
        mainParams["coinId"] = coinId
        mainParams["paymentMethod"] = paymentMethod
        mainParams["quoteId"] = quoteId
        
        return mainParams
    }
}
