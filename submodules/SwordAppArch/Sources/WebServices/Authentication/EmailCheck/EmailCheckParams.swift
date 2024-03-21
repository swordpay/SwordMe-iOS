//
//  EmailCheckParams.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 24.01.23.
//

import Foundation

struct EmailCheckParams: Routing {
    let email: String

    var key: APIRepresentable {
        return Constants.AuthenticationAPI.emailCheck
    }
    
    var params: [String : Any] {
        return ["email": email]
    }
    
    var acceptableStatusCodes: Set<Int> {
        return [ 201 ]
    }
}
