//
//  CryptoModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 10.02.23.
//

import Combine
import Foundation

public final class CryptoModel {
    var id: String
    var name: String
    var abbreviation: String
    var priceToMainCoin: Double
    var priceInEuro: CurrentValueSubject<Double, Never>
    var iconPath: String
    var oscillation: CurrentValueSubject<String, Never>
    var oscillationByPercent: CurrentValueSubject<String, Never>
    let networks: [CryptoNetworkModel]
    let freeze: Int
    let locked: Int
    var accountInfo: CryptoAccountModel?
    
    init(id: String,
         name: String,
         abbreviation: String,
         priceToMainCoin: Double,
         priceInEuro: Double,
         iconPath: String,
         oscillation: String,
         oscillationByPercent: String,
         networks: [CryptoNetworkModel],
         freeze: Int,
         locked: Int,
         accountInfo: CryptoAccountModel? = nil) {
        self.id = id
        self.name = name
        self.abbreviation = abbreviation
        self.priceToMainCoin = priceToMainCoin
        self.priceInEuro = CurrentValueSubject(priceInEuro)
        self.iconPath = iconPath
        self.oscillation = CurrentValueSubject(oscillation)
        self.oscillationByPercent = CurrentValueSubject(oscillationByPercent)
        self.networks = networks
        self.freeze = freeze
        self.locked = locked
        self.accountInfo = accountInfo
    }
    
    func cryptoMainInfo() -> GetCryptoAssetsResponse.CryptoMainInfo {
        return .init(name: name,
                     coin: abbreviation,
                     balance: accountInfo?.balance.value,
                     freeze: freeze,
                     locked: locked,
                     networks: networks)
    }
}
