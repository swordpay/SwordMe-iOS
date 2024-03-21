//
//  GetChannelMessagesParams.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 29.03.23.
//

import Foundation

struct GetChannelMessagesParams: Routing {
    let channelId: Int
    let limit: Int
    let beforeMessageId: Int?
    let afterMessageId: Int?
    
    init(channelId: Int, limit: Int = 40, beforeMessageId: Int? = nil, afterMessageId: Int? = nil) {
        self.channelId = channelId
        self.limit = limit
        self.beforeMessageId = beforeMessageId
        self.afterMessageId = afterMessageId
    }

    var key: APIRepresentable {
        return Constants.ChannelsAPI.getChannelMessages(channelId: channelId)
    }
    
    var httpMethod: URLRequestMethod {
        return .get
    }
    
    var params: [String : Any] {
        var params: [String: Any] = ["limit": limit]

        if let beforeMessageId {
            params["beforeId"] = beforeMessageId
        }
        
        if let afterMessageId {
            params["afterId"] = afterMessageId
        }

        return params
    }
    
    var paramsEncoder: URLRequestParameterEncoding {
        return URLRequestParameterURLEncoder()
    }
}
