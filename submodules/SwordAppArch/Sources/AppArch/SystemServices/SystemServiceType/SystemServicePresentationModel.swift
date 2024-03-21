//
//  SystemServicePresentationModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 18.04.22.
//

import Foundation

protocol SystemServicePresentationModel {
    var title: String { get }
    var description: String { get }
    var iconName: String { get }
    var hasAction: Bool { get }

    func action()
}

extension SystemServicePresentationModel {
    var hasAction: Bool { return true }
}
