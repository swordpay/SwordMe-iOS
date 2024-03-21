//
//  AssetsPricesOnMainCoinParams.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 16.03.23.
//

import Foundation

struct AssetsPricesOnMainCoinParams: Routing {
    let symbols: String
    
    init(symbols: String) {
        self.symbols = symbols
    }

    var baseURL: URL {
        return Constants.AppURL.networkingBinanceMainURL
    }

    var key: APIRepresentable {
        return Constants.CryptoAPI.assetsPricesOnMainCoin
    }
    
    var httpMethod: URLRequestMethod {
        return .get
    }
    
    var request: URLRequest {
        let newPath = baseURL.appendingPathComponent("\(key.path)\(symbols)")
                             .absoluteString.replacingOccurrences(of: ",", with: "%2C")
                             .replacingOccurrences(of: "%3F", with: "?")
        let newURL = URL(string: newPath)!
        var request = URLRequest(url: newURL)
        request.httpMethod = "GET"

        return request
    }
    
    var paramsEncoder: URLRequestParameterEncoding {
        return URLRequestParameterURLEncoder()
    }
    
    var isAuthorized: Bool {
        return false
    }
    
    var isBinanceReqeust: Bool {
        return true
    }
}
