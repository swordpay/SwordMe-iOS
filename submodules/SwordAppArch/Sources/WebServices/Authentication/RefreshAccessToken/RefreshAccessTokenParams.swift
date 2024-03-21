//
//  RefreshAccessTokenParams.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 25.01.23.
//

import Foundation

public struct RefreshAccessTokenParams: Routing {
    public var key: APIRepresentable {
        return Constants.AuthenticationAPI.refreshAccessToken
    }
    
    public var headers: [String : String] {
        return [ "Authorization": "Bearer \(AppData.accessToken ?? "")" ]
    }
    
    public var isAuthorized: Bool {
        return false
    }
    
    public var acceptableStatusCodes: Set<Int> {
        return [ 201 ]
    }
}
