//
//  ResendVerificationCodeParams.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 24.01.23.
//

import Foundation

struct ResendVerificationCodeParams: Routing {
    var key: APIRepresentable {
        return Constants.AuthenticationAPI.resendVerificationCode
    }
    
    var acceptableStatusCodes: Set<Int> {
        return [ 201 ]
    }
}
