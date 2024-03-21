//
//  GetCryptoBalanceParams.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 13.03.23.
//

import Foundation

struct GetCryptoBalanceParams: Routing {
    let currency: String
    
    init(currency: String = "EUR") {
        self.currency = currency
    }
    
    var key: APIRepresentable {
        return Constants.CryptoAPI.balance
    }
    
    var httpMethod: URLRequestMethod {
        return .get
    }
    var paramsEncoder: URLRequestParameterEncoding {
        return URLRequestParameterURLEncoder()
    }
}
