//
//  GetUserParams.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 26.01.23.
//

import Foundation

public struct GetUserParams: Routing {
    
    public init() {
        
    }

    public var key: APIRepresentable {
        return Constants.UserAPI.getUser
    }
    
    public var httpMethod: URLRequestMethod {
        return .get
    }

    public var paramsEncoder: URLRequestParameterEncoding {
        return URLRequestParameterURLEncoder()
    }
}
