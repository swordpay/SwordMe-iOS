//
//  AssetsPricesChangesResponse.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 17.03.23.
//

import Foundation

struct AssetsPricesChangesResponse: Codable {
    let symbol: String
    let lastPrice: String
    let priceChange: String
    let priceChangePercent: String
    let prevClosePrice: String
    
    var usablePrice: String {
        guard let doubledLastPrice = Double(lastPrice), doubledLastPrice > 0 else { return prevClosePrice }
        
        return lastPrice
    }
}
