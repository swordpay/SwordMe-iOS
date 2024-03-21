//
//  GetChannelsParams.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 28.03.23.
//

import Foundation

final class GetChannelsParams: Routing {
    let beforeChannelId: Int?
    let afterChannelId: Int?
    let type: `Type`?
    let hasAvatar: Bool?
    let afterDate: String?
    
    let limit: Int

    init(beforeChannelId: Int? = nil,
         afterChannelId: Int? = nil,
         type: `Type`? = nil,
         hasAvatar: Bool? = nil,
         limit: Int = 10,
         afterDate: String? = nil) {
        self.beforeChannelId = beforeChannelId
        self.afterChannelId = afterChannelId
        self.type = type
        self.hasAvatar = hasAvatar
        self.limit = limit
        self.afterDate = afterDate
    }

    var key: APIRepresentable {
        return Constants.ChannelsAPI.getChannels
    }
    
    var httpMethod: URLRequestMethod {
        return .get
    }
    
    var params: [String : Any] {
        if let afterDate {
            return ["afterDate": afterDate,
                    "limit": 0]
        }

        var params: [String: Any] = ["limit": limit ]

        if let beforeChannelId {
            params["beforeId"] = beforeChannelId
        }
        
        if let afterChannelId {
            params["afterId"] = afterChannelId
        }
        
        if let hasAvatar {
            params["hasAvatar"] = hasAvatar
        }

        if let type {
            params["type"] = type.rawValue
        }

        return params
    }
    
    var paramsEncoder: URLRequestParameterEncoding {
        return URLRequestParameterURLEncoder()
    }
}

extension GetChannelsParams {
    enum `Type`: String {
        case direct
        case group
        case `private`
        case publicChannel = "public_channel"
    }
}
