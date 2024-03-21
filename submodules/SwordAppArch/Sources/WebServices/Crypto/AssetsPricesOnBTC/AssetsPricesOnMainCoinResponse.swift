//
//  AssetsPricesOnMainCoinResponse.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 16.03.23.
//

import Foundation

struct AssetsPricesOnMainCoinResponse: Codable {
    let symbol: String
    var price: String
}
