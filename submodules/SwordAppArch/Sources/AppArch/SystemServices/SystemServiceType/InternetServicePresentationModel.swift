//
//  InternetServicePresentationModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 18.04.22.
//

import UIKit
import Swinject

final class InternetServicePresentationModel: SystemServicePresentationModel {
    var title: String { return "" }
    var description: String { return Constants.Localization.SystemService.internetDescription }
    var iconName: String { return Constants.AssetName.Common.noInternetConnection }

    var hasAction: Bool { return false }

    func action() { }
}

final class InternetServicePresentationModelAssembly: Assembly {
    func assemble(container: Container) {
        container.register(SystemServicePresentationModel.self) { _ in
            return InternetServicePresentationModel()
        }
    }
}
