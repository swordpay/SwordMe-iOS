//
//  DeleteChannelParams.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 31.05.23.
//

import Foundation

struct DeleteChannelParams: Routing {
    let channelId: Int
    
    var key: APIRepresentable {
        return Constants.ChannelsAPI.deleteChannel(channelId: channelId)
    }
    
    var httpMethod: URLRequestMethod {
        return .delete
    }
}
