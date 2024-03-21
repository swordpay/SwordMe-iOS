//
//  SystemServicePermissionAccessViewModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 09.02.23.
//

import Combine
import Foundation

enum SystemServicePermissionType {
    case contacts
    case camera
    
    var title: String {
        switch self {
        case .contacts:
            return Constants.Localization.SystemService.contactAccessTitle
        case .camera:
            return Constants.Localization.SystemService.cameraTitle
        }
    }
    
    var description: String {
        switch self {
        case .contacts:
            return Constants.Localization.SystemService.contactAccessDescription
        case .camera:
            return Constants.Localization.SystemService.cameraDescription
        }
    }
    
    var iconName: String {
        switch self {
        case .contacts:
            return Constants.AssetName.Common.contactsAccess
        case .camera:
            return Constants.AssetName.Common.cameraAccess
        }
    }
}

final class SystemServicePermissionAccessViewModel {
    let systemService: SystemServicePermissionType
    let hasCloseButton: Bool
    
    let closeButtonActionPublisher: PassthroughSubject<Void, Never> = PassthroughSubject()

    init(systemService: SystemServicePermissionType, hasCloseButton: Bool = false) {
        self.systemService = systemService
        self.hasCloseButton = hasCloseButton
    }
}
