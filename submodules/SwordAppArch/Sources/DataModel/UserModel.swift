//
//  UserModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 05.12.22.
//

import Foundation

public struct UserModel: Codable {
    var id: String
    var firstName: String?
    var lastName: String?
    var username: String?
    var email: String?
    var avatar: String?
    var phoneNumber: String
    var dateOfBirth: String?
    var type: String
    var status: Status
    var hasCryptoAccount: Bool
    var hasFiatAccount: Bool
    var isEmailVerified: Bool
//    let isPhoneVerified: Bool
    var country: CountryModel?
    
    var fullName: String {
        return (firstName ?? "") + " " + (lastName ?? "")
    }
    enum CodingKeys: String, CodingKey {
        case id
        case firstName
        case lastName
        case username
        case email
        case avatar
        case phoneNumber = "phone"
        case dateOfBirth = "birthday"
        case type
        case status
        case hasCryptoAccount
        case hasFiatAccount
        case isEmailVerified
//        case isPhoneVerified
        case country
    }
    
    enum Status: String, Codable {
        case active
        case inactive
    }
}

public struct PaymentUserModel: Codable {
    var id: String
    var firstName: String
    var lastName: String
    var username: String
    var email: String
    var phoneNumber: String
    var dateOfBirth: String
    var type: String
    var hasCryptoAccount: Bool
    var hasFiatAccount: Bool
    var isEmailVerified: Bool
    
    var fullName: String {
        return firstName + " " + lastName
    }
    enum CodingKeys: String, CodingKey {
        case id
        case firstName
        case lastName
        case username
        case email
        case phoneNumber = "phone"
        case dateOfBirth = "birthday"
        case type
        case hasCryptoAccount
        case hasFiatAccount
        case isEmailVerified
    }
}

