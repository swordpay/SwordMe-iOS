//
//  ForgotPasswordParams.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 25.01.23.
//

import Foundation

struct ForgotPasswordParams: Routing {
    let login: String

    var key: APIRepresentable {
        return Constants.PasswordAPI.forgot
    }
    
    var params: [String : Any] {
        return ["login": login]
    }
    
    var isAuthorized: Bool {
        return false
    }
}
