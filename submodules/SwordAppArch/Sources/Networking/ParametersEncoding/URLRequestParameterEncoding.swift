//
//  URLRequestParameterEncoding.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 12.04.22.
//

import Foundation

public protocol URLRequestParameterEncoding {
    func encode(params: [String: Any], for request: inout URLRequest)
}
