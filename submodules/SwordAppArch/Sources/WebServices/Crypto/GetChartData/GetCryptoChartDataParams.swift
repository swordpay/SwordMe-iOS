//
//  GetCryptoChartDataParams.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 23.03.23.
//

import Foundation

struct GetCryptoChartDataParams: Routing {
    let symbol: String
    let startTime: Int
    let interval: String

    var baseURL: URL {
        return Constants.AppURL.networkingBinanceMainURL
    }

    var key: APIRepresentable {
        return Constants.CryptoAPI.cryptoChartData(symbol: symbol, startTime: startTime, interval: interval)
    }

    var httpMethod: URLRequestMethod {
        return .get
    }

    var request: URLRequest {
        let newPath = baseURL.appendingPathComponent("\(key.path)")
                             .absoluteString
                             .replacingOccurrences(of: "%3F", with: "?")
        let newURL = URL(string: newPath)!
        var request = URLRequest(url: newURL)
        request.httpMethod = httpMethod.rawValue

        return request
    }

    var isAuthorized: Bool {
        return false
    }
    
    var isBinanceReqeust: Bool {
        return true
    }
}
