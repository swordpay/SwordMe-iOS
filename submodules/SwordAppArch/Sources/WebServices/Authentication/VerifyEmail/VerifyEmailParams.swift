//
//  VerifyEmailParams.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 10.05.23.
//

import Foundation

struct VerifyEmailParams: Routing {
    var key: APIRepresentable {
        return Constants.AuthenticationAPI.verifyEmail
    }
}
