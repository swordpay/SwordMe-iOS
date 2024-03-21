//
//  SingleItemBaseResponse.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 23.02.23.
//

import Foundation

public struct SingleItemBaseResponse<Response: Codable>: Codable {
    let statusCode: Int
    let statusName: String
    public let data: Response
}

public struct OnrampBaseResponse<Response: Codable>: Codable {
    public let message: Response
}
