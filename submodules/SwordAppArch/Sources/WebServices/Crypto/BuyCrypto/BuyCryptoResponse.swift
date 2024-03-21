//
//  BuyCryptoResponse.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 20.03.23.
//

import Foundation

struct BuyCryptoResponse: Codable {
    let redirectUrl: String?
    let type: RedirectionType?
    
    enum RedirectionType: String, Codable {
        case popup
        case iframe
    }
}
