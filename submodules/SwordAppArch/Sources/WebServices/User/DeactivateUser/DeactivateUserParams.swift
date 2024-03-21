//
//  DeactivateUserParams.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 10.05.23.
//

import Foundation

struct DeactivateUserParams: Routing {
    var key: APIRepresentable {
        return Constants.UserAPI.deactivate
    }
    
    var httpMethod: URLRequestMethod {
        return .put
    }
}
