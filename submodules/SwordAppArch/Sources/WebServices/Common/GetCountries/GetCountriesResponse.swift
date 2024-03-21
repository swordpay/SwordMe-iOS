//
//  GetCountriesResponse.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 23.01.23.
//

import Foundation

public struct GetCountriesResponse: Codable {
    public let statusCode: Int
    public let statusName: String
    public let countries: [CountryModel]
}
