//
//  TopUpStackViewModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 25.05.23.
//

import Combine
import Foundation

final class TopUpStackViewModel {
    let closeButtonTapHandler: PassthroughSubject<Void, Never> = .init()
    let topUpButtonTapHandler: PassthroughSubject<Void, Never> = .init()
    
    lazy var topUpButtonViewModel: GradientedButtonModel = {
        return GradientedButtonModel(title: Constants.Localization.FiatAccount.topUp,
                                     hasBorders: false,
                                     isActive: true,
                                     action: { [ weak self ] in
            self?.topUpButtonTapHandler.send(())
        })
    }()
}
