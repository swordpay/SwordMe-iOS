//
//  OnboardingUserModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 24.01.23.
//

import Foundation

public struct OnboardingUserModel: Codable {
    var id: String?
    var firstName: String?
    var lastName: String?
    var username: String?
    var email: String?
    var avatar: Data?
    var phoneNumber: String?
    var dateOfBirth: String?
    var country: CountryModel?
    var type: String?
    var isPrivacyCheckboxSelected: Bool = false
    
    func toDictionary() -> [String: Any] {
        guard let firstName,
              let lastName,
              let username,
              let email,
              let phoneNumber,
              let type,
              let dateOfBirth,
              let countryId = country?.id else { return [:] }
        
        return ["firstName": firstName,
                "lastName": lastName,
                "username": username,
                "birthday": dateOfBirth,
                "type": type,
                "email": email,
                "phone": phoneNumber,
                "countryId": countryId
               ]
    }
}
