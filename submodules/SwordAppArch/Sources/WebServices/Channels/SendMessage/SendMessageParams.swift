//
//  SendMessageParams.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 29.03.23.
//

import Foundation

struct SendMessageParams: Routing {
    let channelId: Int
    let message: String
    let referenceId: String
    
    var key: APIRepresentable {
        return Constants.ChannelsAPI.sendMessage(channelId: channelId)
    }
    
    var params: [String : Any] {
        return ["message": message,
                "referenceId": referenceId]
    }
}
