//
//  GetLatestPaymentsResponse.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 07.04.23.
//

import Foundation

struct GetLatestPaymentsResponse: Codable {
    let statusCode: Int
    let statusName: String
    let rooms: [ChannelItemModel]
    
    enum CodingKeys: String, CodingKey {
        case statusCode
        case statusName
        case rooms
    }
}

