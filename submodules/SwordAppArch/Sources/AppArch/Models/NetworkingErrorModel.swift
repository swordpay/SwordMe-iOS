//
//  NetworkingErrorModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 29.06.22.
//

import Foundation

public struct NetworkingErrorModel: Codable {
    let statusName: String
    let statusCode: Int
    let message: String?
    let errors: [ErrorInfo]?
}

extension NetworkingErrorModel {
    public struct ErrorInfo: Codable {
        let field: String?
        let message: String
    }
}
