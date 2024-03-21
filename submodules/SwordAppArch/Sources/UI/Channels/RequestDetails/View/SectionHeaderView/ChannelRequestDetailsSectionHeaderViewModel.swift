//
//  ChannelRequestDetailsSectionHeaderViewModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 29.12.22.
//

import Combine
import Foundation

final class ChannelRequestDetailsSectionHeaderViewModel: Emptiable {
    var isEmpty: Bool { return false }
    
    var hasPayment: Bool
    var sendReminderPublisher: PassthroughSubject<Void, Never> = PassthroughSubject()
    
    init(hasPayment: Bool) {
        self.hasPayment = hasPayment
    }
}
