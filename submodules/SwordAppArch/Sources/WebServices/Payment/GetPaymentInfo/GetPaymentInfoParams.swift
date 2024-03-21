//
//  GetPaymentInfoParams.swift
//  SwordAppArch
//
//  Created by Tigran Simonyan on 24.08.23.
//

import Foundation

public struct GetPaymentInfoParams: Routing {
    private let paymentId: String
    
    public var key: APIRepresentable {
        return Constants.PaymentsAPI.getPaymentInfo(paymentId: paymentId)
    }
    
    public var httpMethod: URLRequestMethod {
        return .get
    }
    
    public init(paymentId: String) {
        self.paymentId = paymentId
    }
    
    public var paramsEncoder: URLRequestParameterEncoding {
        return URLRequestParameterURLEncoder()
    }
}
