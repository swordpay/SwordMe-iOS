//
//  PhoneNumberParams.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 07.12.22.
//

import Foundation

struct PhoneNumberParams: Routing {
    let phoneNumber: String
    
    var key: APIRepresentable {
        return Constants.AuthenticationAPI.phoneNumber
    }
    
    var httpMethod: URLRequestMethod {
        return .post
    }
    
    var params: [String : Any] {
        return ["phoneNumber": phoneNumber]
    }
    
    var paramsEncoder: URLRequestParameterEncoding {
        return URLRequestParameterJSONEncoder()
    }
}
