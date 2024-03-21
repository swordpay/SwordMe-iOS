//
//  CreateDMChannelParams.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 27.03.23.
//

import Foundation

struct CreateDMChannelParams: CreateChannelRouting {
    let receiverId: Int
    
    var key: APIRepresentable {
        return Constants.ChannelsAPI.createDMChannel
    }
    
    var params: [String : Any] {
        return ["receiverId": receiverId]
    }
}
