//
//  CountryModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 19.01.23.
//

import Foundation

public struct CountryModel: Codable {
    let id: Int
    let name: String
    let code: String
    let alpha2: String
    let alpha3: String
    var flagPath: String?
    var continent: String?
    let createdAt: String
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case code = "phoneCode"
        case alpha2
        case alpha3
        case createdAt
        case updatedAt
        case flagPath = "flag"
        case continent
    }
}

extension CountryModel {
    static var dummyCountry: CountryModel {
        return CountryModel(id: 7, name: "Armenia", code: "+374", alpha2: "AM", alpha3: "ARM", createdAt: "", updatedAt: "")
    }
}
