//
//  VerifyEmailTokenParams.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 10.05.23.
//

import Foundation

public struct VerifyEmailTokenParams: Routing {
    let token: String
    
    public var key: APIRepresentable {
        return Constants.AuthenticationAPI.verifyEmailToken
    }
    
    public var params: [String : Any] {
        return ["authorization": token]
    }
    
    public init(token: String) {
        self.token = token
    }
}
