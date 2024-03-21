//
//  GetCryptoAssetsParams.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 13.03.23.
//

import Foundation

struct GetCryptoAssetsParams: Routing {
    var areOnlyStableCoins: Bool
    
    init(areOnlyStableCoins: Bool = false) {
        self.areOnlyStableCoins = areOnlyStableCoins
    }
    
    var key: APIRepresentable {
        return Constants.CryptoAPI.assetsList
    }
    
    var httpMethod: URLRequestMethod {
        return .get
    }
    
    var params: [String : Any] {
        return ["onlyStable": areOnlyStableCoins]
    }

    var paramsEncoder: URLRequestParameterEncoding {
        return URLRequestParameterURLEncoder()
    }
}
