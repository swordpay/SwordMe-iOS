//
//  GetChannelsResponse.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 28.03.23.
//

import Foundation

struct GetChannelsResponse: Codable, MetadataPresentable {
    let statusCode: Int
    let statusName: String
    let channels: [ChannelItemModel]
    let metadata: ResponseMetaData?
    
    enum CodingKeys: String, CodingKey {
        case statusCode
        case statusName
        case channels = "rooms"
        case metadata = "_meta"
    }
}
