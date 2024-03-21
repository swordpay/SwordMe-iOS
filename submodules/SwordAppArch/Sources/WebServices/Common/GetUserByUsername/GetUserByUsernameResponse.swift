//
//  GetUserByUsernameResponse.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 31.03.23.
//

import Foundation

public struct GetUserByUsernameResponse: Codable {
    let statusCode: Int
    let statusName: String
    public let user: ChannelUserModel?
}
