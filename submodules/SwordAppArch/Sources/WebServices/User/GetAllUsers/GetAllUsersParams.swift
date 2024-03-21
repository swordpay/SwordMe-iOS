//
//  GetAllUsersParams.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 05.04.23.
//

import Foundation

struct GetAllUsersParams: Routing {
    let searchTerm: String?
    let limit: Int
    let offset: Int
    
    var key: APIRepresentable {
        return Constants.UserAPI.getAllUser
    }
    
    var httpMethod: URLRequestMethod {
        return .get
    }
    
    
    var params: [String : Any] {
        var mainParams: [String: Any] = [
            "limit": limit,
            "offset": offset
        ]
        
        if let searchTerm {
            mainParams["search"] = searchTerm
        }
        
        return mainParams
    }

    var paramsEncoder: URLRequestParameterEncoding {
        return URLRequestParameterURLEncoder()
    }
}
