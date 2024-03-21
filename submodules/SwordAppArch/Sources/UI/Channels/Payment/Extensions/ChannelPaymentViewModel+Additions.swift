//
//  ChannelPaymentViewModel+Additions.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 13.04.23.
//

import Foundation

public extension ChannelPaymentViewModel {
    enum RedirectingSource: String, Codable {
        case accountConsent
        case payment
    }
}

public extension ChannelPaymentViewModel {
    enum Source: String, Codable {
        case chat
        case createPayment
    }
}

public extension ChannelPaymentViewModel {
    enum EmptyStateReason {
        case redirectURL
        case error
    }
}
