//
//  ChannelUserModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 05.04.23.
//

import Foundation

public struct ChannelUserModel: Codable, Hashable {
    let id: String
    let firstName: String
    let lastName: String
    let username: String
    let avatar: String?
    
    var fullName: String {
        return firstName + " " + lastName
    }
}
