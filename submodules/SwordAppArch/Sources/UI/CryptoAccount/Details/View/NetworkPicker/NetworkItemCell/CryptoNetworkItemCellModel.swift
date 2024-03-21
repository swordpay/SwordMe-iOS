//
//  CryptoNetworkItemCellModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 29.05.23.
//

import Foundation

final class CryptoNetworkItemCellModel {
    static var reusableIdentifier: String {
        return String(describing: CryptoNetworkItemCell.self)
    }
    
    let network: CryptoNetworkModel
    
    init(network: CryptoNetworkModel) {
        self.network = network
    }
}
