//
//  AccountsBalanceResponse.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 30.03.23.
//

import Foundation

public struct AccountsBalanceResponse: Codable {
    public var crypto: [CoinBalanceModel]?
    public var redirectUrl: String?
    public var mainCoin: String?
    
    public var hasEnoughtCrypto: Bool {
        guard let crypto,
              crypto.reduce(0, { $0 + $1.balance } ) != 0 else { return false }
        
        return true
    }

    public var hasEnoughtBalance: Bool {
        true
    }
}
