//
//  AmountType.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 23.05.23.
//

import Foundation

enum AmountType: String {
    case fiat
    case crypto
    
    var title: String {
        switch self {
        case .fiat:
            return Constants.Localization.Common.cash
        case .crypto:
            return Constants.Localization.Common.crypto
        }
    }
}
