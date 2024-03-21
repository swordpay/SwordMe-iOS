//
//  DeleteAvatarParams.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 04.04.23.
//

import Foundation

struct DeleteAvatarParams: Routing {
    var key: APIRepresentable {
        return Constants.UserAPI.avatar
    }
    
    var httpMethod: URLRequestMethod {
        return .delete
    }
}
