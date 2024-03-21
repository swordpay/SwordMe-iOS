//
//  GetLatestPaymentsParams.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 07.04.23.
//

import Foundation

struct GetLatestPaymentsParams: Routing {
    var key: APIRepresentable {
        return Constants.PaymentsAPI.latest
    }
    
    var httpMethod: URLRequestMethod {
        return .get
    }
    
    var paramsEncoder: URLRequestParameterEncoding {
        return URLRequestParameterURLEncoder()
    }
}
