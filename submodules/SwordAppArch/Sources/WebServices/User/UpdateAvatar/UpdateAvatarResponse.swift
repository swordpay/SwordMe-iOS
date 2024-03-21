//
//  UpdateAvatarResponse.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 04.04.23.
//

import Foundation

struct UpdateAvatarResponse: Codable {
    let media: Media
    
    struct Media: Codable {
        let path: String
    }
}
