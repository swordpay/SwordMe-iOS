//
//  DeleteAvatarResponse.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 04.04.23.
//

import Foundation

struct DeleteAvatarResponse: Codable {
    let media: Media
    
    struct Media: Codable {
        let success: Bool
    }
}
