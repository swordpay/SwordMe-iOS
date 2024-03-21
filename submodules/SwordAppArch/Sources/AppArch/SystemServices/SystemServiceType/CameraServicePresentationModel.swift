//
//  CameraServicePresentationModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 18.04.22.
//

import UIKit
import Swinject

final class CameraServicePresentationModel: SystemServicePresentationModel {
    var title: String { return Constants.Localization.SystemService.cameraTitle }
    var description: String { return Constants.Localization.SystemService.cameraDescription }
    var iconName: String { return "" } // TODO: - Set correct Asset

    func action() {
        CameraManagerProvider.native.authorizeCameraAccess()
    }
}

final class CameraServicePresentationModelAssembly: Assembly {
    func assemble(container: Container) {
        container.register(SystemServicePresentationModel.self) { _ in
            return CameraServicePresentationModel()
        }
    }
}
