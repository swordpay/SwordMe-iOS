//
//  MakePaymentResponse.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 31.03.23.
//

import Foundation

struct MakePaymentResponse: Codable {
    var redirectUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case redirectUrl
    }
}
