//
//  VerifyPhoneNumberResponse.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 07.12.22.
//

import Foundation

struct VerifyPhoneNumberResponse: Codable {
    var accessToken: String
    var code: String?
    var refreshToken: String?
    var immortalToken: String?
}
