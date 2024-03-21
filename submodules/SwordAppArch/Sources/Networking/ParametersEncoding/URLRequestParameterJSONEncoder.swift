//
//  URLRequestParameterJSONEncoder.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 12.04.22.
//

import Foundation

public final class URLRequestParameterJSONEncoder: URLRequestParameterEncoding {
    public func encode(params: [String : Any], for request: inout URLRequest) {
        let data = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)

        request.httpBody = data
    }
}
