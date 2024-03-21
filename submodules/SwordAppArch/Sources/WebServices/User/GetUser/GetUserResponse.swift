//
//  GetUserResponse.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 26.01.23.
//

import Foundation

public struct GetUserResponse: Codable {
    let statusCode: Int
    let statusName: String

    public let data: Info
    
    public var user: UserModel {
        return data.user
    }
}

extension GetUserResponse {
    public struct Info: Codable {
        let user: UserModel
    }
}
