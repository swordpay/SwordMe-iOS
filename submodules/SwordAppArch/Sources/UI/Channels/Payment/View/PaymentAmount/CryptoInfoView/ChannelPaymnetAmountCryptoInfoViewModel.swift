//
//  ChannelPaymnetAmountCryptoInfoViewModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 22.05.23.
//

import Combine
import Foundation

final class ChannelPaymnetAmountCryptoInfoViewModel {
    var cryptoModel: CurrentValueSubject<ChannelPaymnetAmountViewModel.CryptoInfo?, Never>
    
    var iconURL: URL? {
        guard let iconPath = cryptoModel.value?.selectedCoin.iconPath,
              let url = URL(string: iconPath) else { return nil }
        
        return url
    }

    init(cryptoModel: ChannelPaymnetAmountViewModel.CryptoInfo?) {
        self.cryptoModel = .init(cryptoModel)
    }
}
