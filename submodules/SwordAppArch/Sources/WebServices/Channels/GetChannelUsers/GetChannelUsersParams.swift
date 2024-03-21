//
//  GetChannelUsersParams.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 30.05.23.
//

import Foundation

struct GetChannelUsersParams: Routing {
    let channelId: Int
    
    var key: APIRepresentable {
        return Constants.ChannelsAPI.getUsers(channelId: channelId)
    }
    
    var httpMethod: URLRequestMethod {
        return .get
    }
    
    var paramsEncoder: URLRequestParameterEncoding {
        return URLRequestParameterURLEncoder()
    }
}
