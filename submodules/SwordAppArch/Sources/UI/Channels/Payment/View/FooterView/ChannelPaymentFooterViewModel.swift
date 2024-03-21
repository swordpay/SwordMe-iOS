//
//  ChannelPaymentFooterViewModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 27.12.22.
//

import Combine
import Foundation

public final class ChannelPaymentFooterViewModel {

    let isPaying: Bool
    
    let transactionButtonHandler: PassthroughSubject<Bool, Never> = .init()
    let note: CurrentValueSubject<String?, Never> = CurrentValueSubject(nil)
    
    var isSendActionAvailable = true
    lazy var requestButtonViewModel: GradientedButtonModel = {
        return GradientedButtonModel(title: Constants.Localization.Common.request,
                                     hasBorders: false,
                                     isActive: false,
                                     action: { [ weak self ] in
            self?.transactionButtonHandler.send(true)
        })
    }()

    lazy var payButtonViewModel: GradientedButtonModel = {
        return GradientedButtonModel(title: Constants.Localization.Common.pay,
                                     hasBorders: false,
                                     isActive: false,
                                     action: { [ weak self ] in
            self?.transactionButtonHandler.send(false)
        })
    }()
    
    init(isPaying: Bool) {
        self.isPaying = isPaying
    }
}
