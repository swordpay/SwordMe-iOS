//
//  AccountsBalanceParams.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 30.03.23.
//

import Foundation
 
public struct AccountsBalanceParams: Routing {
    public var key: APIRepresentable {
        return Constants.CommonAPI.accountsBalance
    }
    
    public var httpMethod: URLRequestMethod {
        return .get
    }
    
    public var paramsEncoder: URLRequestParameterEncoding {
        return URLRequestParameterURLEncoder()
    }
}
