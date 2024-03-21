//
//  CryptoTradeInfoParams.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 19.03.23.
//

import Foundation

struct CryptoTradeInfoParams: Routing {
    let currency: String
    let coin: String
    let action: CryptoActionType
    
    init(currency: String = "EUR",
         coin: String,
         action: CryptoActionType) {
        self.currency = currency
        self.coin = coin
        self.action = action 
    }
    
    var key: APIRepresentable {
        return Constants.CryptoAPI.tradeInfo
    }
    
    var httpMethod: URLRequestMethod {
        return .get
    }
    
    var params: [String : Any] {
        return ["currency": currency,
                "coin": coin,
                "type": action.rawValue]
    }
    
    var paramsEncoder: URLRequestParameterEncoding {
        return URLRequestParameterURLEncoder()
    }
}
