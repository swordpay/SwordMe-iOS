//
//  URLRequestParameterURLEncoder.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 12.04.22.
//

import Foundation

public final class URLRequestParameterURLEncoder: URLRequestParameterEncoding {
    public func encode(params: [String : Any], for request: inout URLRequest) {
        guard let url = request.url, !params.isEmpty else { return }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        let existingQueryItem = components?.queryItems ?? []
        components?.queryItems = params.map { URLQueryItem(name: $0, value: "\($1)") } + existingQueryItem
        
        request.url = components?.url
    }
}
