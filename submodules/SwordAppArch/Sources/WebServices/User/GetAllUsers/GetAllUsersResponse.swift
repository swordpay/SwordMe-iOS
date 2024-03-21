//
//  GetAllUsersResponse.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 05.04.23.
//

import Foundation

struct GetAllUsersResponse: Codable, MetadataPresentable {
    let statusCode: Int
    let statusName: String
    let users: [ChannelUserModel]
    let metadata: ResponseMetaData?
    
    enum CodingKeys: String, CodingKey {
        case statusCode
        case statusName
        case users
        case metadata = "_meta"
    }
}
