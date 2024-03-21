//
//  CryptoNetworkPickerViewModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 29.05.23.
//

import Combine
import Foundation

final class CryptoNetworkPickerViewModel {
    let networks: [CryptoNetworkModel]
    let isForDeposit: Bool
    let selectedNetwork: PassthroughSubject<CryptoNetworkModel, Never> = PassthroughSubject()
    let closeButtonHandler: PassthroughSubject<Void, Never> = PassthroughSubject()

    init(networks: [CryptoNetworkModel], isForDeposit: Bool) {
        self.networks = networks
        self.isForDeposit = isForDeposit
    }
}
