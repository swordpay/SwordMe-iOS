//
//  GetCryptoChartDataResponse.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 23.03.23.
//

import Foundation

struct GetCryptoChartDataResponse: Codable {
    let openTime: Double
    let price: String
    
    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        
        self.openTime = try container.decode(Double.self)
        
        for _ in (1...3) {
            let _ = try container.decode(String.self)
        }
        
        self.price = try container.decode(String.self)
    }
}
