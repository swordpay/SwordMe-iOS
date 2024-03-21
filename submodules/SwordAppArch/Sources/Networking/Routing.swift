//
//  Routing.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 12.04.22.
//

import UIKit

public enum URLRequestMethod: String {
    case get = "GET"
    case delete = "DELETE"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
}

public protocol Routing {
    var key: APIRepresentable { get }
    var baseURL: URL { get }
    var authorizationToken: String? { get }
    var request: URLRequest { get }
    var httpMethod: URLRequestMethod { get }
    var headers: [String: String] { get }
    var params: [String: Any] { get }
    var paramsEncoder: URLRequestParameterEncoding { get }
    var isAuthorized: Bool { get }
    var hasAPIType: Bool { get }
    var isBinanceReqeust: Bool { get }
    var isAppActive: Bool { get }
    var acceptableStatusCodes: Set<Int> { get }
}

public extension Routing {
    var baseURL: URL {
        return Constants.AppURL.networkingBaseURL
    }
    
    var authorizationToken: String? {
        return "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY5NzQxNzBhLTRmNjUtNDI0Yy04Mjc1LTk2OGY1ODlkZmVkMiIsImN1c3RvbWVySWQiOiJiZDAwZTY2Zi1jMjFlLTQ0ZWQtOTQ4Ni0zYjNhZGE2MDdkNDIiLCJ0ZWxlZ3JhbUlkIjoiOTEzNjAxMTkyIiwiaWF0IjoxNzEwOTIxMTYxLCJleHAiOjE3NjY0NzY3MTZ9.tOIeOIY9Hs96U6_4Wr48fhIB9i7v3dn3Nx9oghKGMBE"
    }

    var request: URLRequest {
        let url = baseURL.appendingPathComponent(key.path)
        var request = URLRequest(url: url)
        var extendedHeaders = headers

        request.httpMethod = httpMethod.rawValue
        paramsEncoder.encode(params: params, for: &request)
        
        extendedHeaders["x-version-name"] = UIApplication.shared.appVersion
        extendedHeaders["x-os"] = "ios"
//
////        if hasAPIType {
////            extendedHeaders["x-api-type"] = "scylla"
////        }
        extendedHeaders["Content-Type"] = "application/json"
        
        // MARK: - SwordChange

        if isAuthorized,
           let authorizationToken  {
            extendedHeaders["Authorization"] = authorizationToken
        }
        
        extendedHeaders.forEach { request.addValue($1, forHTTPHeaderField: $0) }

        return request
    }

    var httpMethod: URLRequestMethod {
        return .post
    }

    var headers: [String: String] {
        return [:]
    }

    var params: [String: Any] {
        return [:]
    }

    var paramsEncoder: URLRequestParameterEncoding {
        return URLRequestParameterJSONEncoder()
    }

    var isAuthorized: Bool {
        return true
    }

    var hasAPIType: Bool {
        return true
    }
    
    var isBinanceReqeust: Bool {
        return false
    }
    
    var isAppActive: Bool {
        return AppData.isAppAcitve
    }
    
    var acceptableStatusCodes: Set<Int> {
        return [ 200, 201 ]
    }
}
