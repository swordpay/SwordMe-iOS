//
//  CryptoDetailsFooterViewModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 09.03.23.
//

import Combine
import Foundation

final class CryptoDetailsFooterViewModel {
    let canBuy: Bool
    let canSell: Bool

    let cryptoActionPublisher: PassthroughSubject<CryptoActionType, Never> = PassthroughSubject()
    
    lazy var buyButtonViewModel: GradientedButtonModel = {
        return GradientedButtonModel(title: Constants.Localization.Common.buy,
                                     hasBorders: false,
                                     isActive: true,
                                     action: { [ weak self ] in
            self?.cryptoActionPublisher.send(.buy)
        })
    }()

    lazy var sellButtonViewModel: GradientedButtonModel = {
        return GradientedButtonModel(title: Constants.Localization.Common.sell,
                                     hasBorders: false,
                                     isActive: true,
                                     action: { [ weak self ] in
            self?.cryptoActionPublisher.send(.sell)
        })
    }()
    
    init(canBuy: Bool, canSell: Bool) {
        self.canBuy = canBuy
        self.canSell = canSell
    }
}
