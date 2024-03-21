//
//  ForgotPasswordResponse.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 25.01.23.
//

import Foundation

struct ForgotPasswordResponse: Codable {
    let type: String
    let accessToken: String?
    let link: String?
    let code: String?
}
