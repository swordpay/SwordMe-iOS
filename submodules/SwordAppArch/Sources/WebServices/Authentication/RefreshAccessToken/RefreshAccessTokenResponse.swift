//
//  RefreshAccessTokenResponse.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 25.01.23.
//

import Foundation

public struct RefreshAccessTokenResponse: Codable {
    var accessToken: String
    var code: String?
    var refreshToken: String
    var immortalToken: String?
}
