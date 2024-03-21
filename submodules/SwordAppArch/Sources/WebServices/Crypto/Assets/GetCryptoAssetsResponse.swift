//
//  GetCryptoAssetsResponse.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 13.03.23.
//

import Foundation

struct GetCryptoAssetsResponse: Codable {
    let userCryptos: [CryptoMainInfo]
    let topCryptos: [CryptoMainInfo]
    let availableCryptos: [CryptoMainInfo]
    let mainCoin: String
    
    var all: [CryptoMainInfo] {
        return userCryptos + topCryptos + availableCryptos
    }

    enum CodingKeys: String, CodingKey {
        case userCryptos = "self"
        case topCryptos = "top"
        case availableCryptos = "available"
        case mainCoin = "main"
    }
}

extension GetCryptoAssetsResponse {
    struct CryptoMainInfo: Codable, Hashable {
        static func == (lhs: GetCryptoAssetsResponse.CryptoMainInfo, rhs: GetCryptoAssetsResponse.CryptoMainInfo) -> Bool {
            lhs.coin == rhs.coin
        }

        func hash(into hasher: inout Hasher) {
            return hasher.combine(coin)
        }

        let name: String
        let coin: String
        var balance: Double?
        let freeze: Int
        let locked: Int
        var networks: [CryptoNetworkModel]

        var iconPath: String {
            return "\(Constants.AppURL.assetsBaseURL)crypto/\(coin).png"
        }

        func toCryptoModel() -> CryptoModel {
            var accountInfo: CryptoAccountModel?
            
            if let balance {
                accountInfo = .init(balance: balance,
                                    balanceInEuro: balance,
                                    totalReturn: 12.1,
                                    totalReturnByPercent: 12.1)
            }
            
            return CryptoModel(id: UUID().uuidString,
                               name: name,
                               abbreviation: coin,
                               priceToMainCoin: 1,
                               priceInEuro: 11.1,
                               iconPath: "",
                               oscillation: "11.1",
                               oscillationByPercent: "11.1",
                               networks: networks,
                               freeze: freeze,
                               locked: locked,
                               accountInfo: accountInfo)
        }
    }
    
}
