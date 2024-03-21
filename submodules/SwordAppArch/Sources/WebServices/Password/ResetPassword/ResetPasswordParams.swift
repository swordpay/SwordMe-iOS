//
//  ResetPasswordParams.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 25.01.23.
//

import Foundation

struct ResetPasswordParams: Routing {
    let token: String
    let password: String

    var key: APIRepresentable {
        return Constants.PasswordAPI.reset
    }

    var httpMethod: URLRequestMethod {
        return .put
    }

    var params: [String : Any] {
        return ["token": token,
                "password": password]
    }
}
