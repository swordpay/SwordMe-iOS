//
//  CoinBalanceModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 30.03.23.
//

import Foundation

public struct CoinBalanceModel: Codable {
    let name: String
    let coin: String
    let balance: Double
    let locked: Int
    let freeze: Int
}
