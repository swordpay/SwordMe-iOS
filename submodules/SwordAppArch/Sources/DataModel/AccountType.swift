//
//  AccountType.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 06.12.22.
//

import Foundation

enum AccountType: String, CaseIterable {
    case personal = "PERSONAL"
    case creator = "CREATOR"
}

extension AccountType {
    var selectedIconName: String {
        switch self {
        case .personal:
            return Constants.AssetName.Authentication.accountTypePersonalSelected
        case .creator:
            return Constants.AssetName.Authentication.accountTypeCreatorSelected
        }
    }
    
    var unselectedIconName: String {
        switch self {
        case .personal:
            return Constants.AssetName.Authentication.accountTypePersonalUnselected
        case .creator:
            return Constants.AssetName.Authentication.accountTypeCreatorUnselected
        }
    }

}
