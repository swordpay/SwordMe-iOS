//
//  ScreenEmptyStateModeling.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 21.04.22.
//

import Foundation

struct ScreenEmptyStateModel {
    var text: String
    var iconName: String
    var action: ActionModel? = nil
}

extension ScreenEmptyStateModel {
    struct ActionModel {
        let title: String
        let handler: Constants.Typealias.VoidHandler
    }
}
