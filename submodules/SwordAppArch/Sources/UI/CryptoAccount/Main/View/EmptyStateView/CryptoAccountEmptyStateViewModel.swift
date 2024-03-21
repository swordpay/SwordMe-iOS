//
//  CryptoAccountEmptyStateViewModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 10.02.23.
//

import Combine
import Foundation

final class CryptoAccountEmptyStateViewModel {
    var topThreeCryptos: CurrentValueSubject<[CryptoModel], Never>
    let goToMarketButtonPublisher: PassthroughSubject<Void, Never> = PassthroughSubject()
    
    var cryptoInfoItemModels: [ CryptoInfoItemViewModel ]{
        return topThreeCryptos.value.enumerated().map {
            let hasSeparator = $0.offset != 2

            return CryptoInfoItemViewModel(cryptoModel: $0.element, hasSeparator: hasSeparator)
        }
    }

    init(topThreeCryptos: [CryptoModel]) {
        self.topThreeCryptos = CurrentValueSubject(topThreeCryptos)
    }
}
