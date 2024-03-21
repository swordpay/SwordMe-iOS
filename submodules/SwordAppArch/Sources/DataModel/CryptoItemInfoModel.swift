//
//  CryptoItemInfoModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 24.03.23.
//

import Foundation

struct CryptoItemInfoModel: Codable {
    let balance: Double?
    let locked: Int
    let freeze: Int
}
