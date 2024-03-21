//
//  GetCountriesParams.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 23.01.23.
//

import Foundation

public struct GetCountriesParams: Routing {
    public var isForDelivery: Bool
    
    init(isForDelivery: Bool = false) {
        self.isForDelivery = isForDelivery
    }

    public var key: APIRepresentable {
        return Constants.CommonAPI.getCountries
    }
    
    public var httpMethod: URLRequestMethod {
        return .get
    }
    
    public var params: [String : Any] {
        guard isForDelivery else { return [:] }
        
        return ["filterBy": "integrations_card_delivery"]
    }
    
    public var paramsEncoder: URLRequestParameterEncoding {
        return URLRequestParameterURLEncoder()
    }
    
    public var isAuthorized: Bool {
        return true
    }
}
