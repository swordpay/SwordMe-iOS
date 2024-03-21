//
//  VerifyPhoneNumberParams.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 07.12.22.
//

import Foundation

struct VerifyPhoneNumberParams: Routing {
    let verificationCode: String
    let reason: PhoneNumberVerificationReason

    var key: APIRepresentable {
        switch reason {
        case .registration, .verification:
            return Constants.AuthenticationAPI.verifPhoneNumber
        case .twoFactorAuthentication:
            return Constants.AuthenticationAPI.twoFactorAuth
        case .changePassword:
            return Constants.PasswordAPI.verifyPhoneForPassword
        }
    }
    
    var httpMethod: URLRequestMethod {
        return .post
    }
    
    var params: [String: Any] {
        return ["code": verificationCode]
    }
    
    var paramsEncoder: URLRequestParameterEncoding {
        return URLRequestParameterJSONEncoder()
    }
}
