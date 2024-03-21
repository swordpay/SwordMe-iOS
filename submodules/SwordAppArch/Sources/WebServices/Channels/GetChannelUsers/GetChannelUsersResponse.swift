//
//  GetChannelUsersResponse.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 30.05.23.
//

import Foundation

struct GetChannelUsersResponse: Codable {
    let statusName: String
    let statusCode: Int
    let users: [ChannelUserModel]
}
