//
//  ChangePasswordParams.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 11.04.23.
//

import Foundation

struct ChangePasswordParams: Routing {
    let oldPassword: String
    let newPassword: String

    var key: APIRepresentable {
        return Constants.PasswordAPI.change
    }
    
    var httpMethod: URLRequestMethod {
        return .put
    }
        
    var params: [String : Any] {
        return ["password": newPassword,
                "oldPassword": oldPassword]
    }
}
