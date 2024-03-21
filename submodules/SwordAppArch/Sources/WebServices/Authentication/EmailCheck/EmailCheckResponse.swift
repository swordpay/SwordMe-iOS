//
//  EmailCheckResponse.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 24.01.23.
//

import Foundation

struct EmailCheckResponse: Codable {
    let isEmailExists: Bool
    
    enum CodingKeys: String, CodingKey {
        case isEmailExists = "emailExists"
    }
}
