//
//  GetChannelMessagesResponse.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 29.03.23.
//

import Foundation

public struct GetChannelMessagesResponse: Codable, MetadataPresentable {
    let statusCode: Int
    let statusName: String
    let messages: [ChannelMessageModel]
    public let metadata: ResponseMetaData?
    
    enum CodingKeys: String, CodingKey {
        case statusCode
        case statusName
        case messages
        case metadata = "_meta"
    }
}
