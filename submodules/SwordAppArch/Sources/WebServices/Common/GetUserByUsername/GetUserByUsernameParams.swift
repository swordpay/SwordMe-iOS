//
//  GetUserByUsernameParams.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 31.03.23.
//

import Foundation

public struct GetUserByUsernameParams: Routing {
    let username: String
    
    public var key: APIRepresentable {
        return Constants.CommonAPI.getUserByUsername(username: username)
    }
    
    public var httpMethod: URLRequestMethod {
        return .get
    }
    
    public var paramsEncoder: URLRequestParameterEncoding {
        return URLRequestParameterURLEncoder()
    }
    
    public init(username: String) {
        self.username = username
    }
}
