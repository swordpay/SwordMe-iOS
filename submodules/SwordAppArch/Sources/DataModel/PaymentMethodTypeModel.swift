//
//  PaymentMethodTypeModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 27.12.22.
//

import Foundation

public enum PaymentMethodType: String, Codable {
    case fiat
    case crypto
}

public struct PaymentMethodTypeModel: Decodable {
    var id: String = UUID().uuidString
    let name: String
    let abbreviation: String
    var icon: String? = nil
}
