//
//  CryptoTradeInfoResponse.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 19.03.23.
//

import Foundation

struct CryptoTradeInfoResponse: Codable {
    let statusCode: Int
    let statusName: String
    let info: Info
}

extension CryptoTradeInfoResponse {
    struct Info: Codable {
        let coin: ValueRange
        let currency: ValueRange
    }
    
    struct ValueRange: Codable {
        let min: Double
        let max: Double
        var precision: Int?
    }
}
