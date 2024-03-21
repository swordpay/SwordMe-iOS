//
//  ResendVerificationCodeResponse.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 24.01.23.
//

import Foundation

struct ResendVerificationCodeResponse: Codable {
    let message: String
    let success: Bool
    let code: String
}
