//
//  GetAssetItemInfoParams.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 24.03.23.
//

import Foundation

struct GetAssetItemInfoParams: Routing {
    let coin: String
    
    var key: APIRepresentable {
        return Constants.CryptoAPI.assetItemInfo(coin: coin)
    }
    
    var httpMethod: URLRequestMethod {
        return .get
    }
    
    var paramsEncoder: URLRequestParameterEncoding {
        return URLRequestParameterURLEncoder()
    }
}
