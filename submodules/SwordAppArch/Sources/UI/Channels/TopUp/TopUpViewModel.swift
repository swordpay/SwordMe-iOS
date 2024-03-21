//
//  TopUpViewModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 25.05.23.
//

import Combine
import Foundation

final class TopUpViewModel: BaseViewModel<Void>, StackViewModeling {
    var setupModel: CurrentValueSubject<TopUpStackViewModel?, Never> = .init(.init())
    
    let paymentMethodType: PaymentMethodType
    
    init(paymentMethodType: PaymentMethodType) {
        self.paymentMethodType = paymentMethodType
        
        super.init(inputs: ())
    }
}
