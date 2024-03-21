//
//  CompletionStackViewModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 27.06.22.
//

import Foundation

final class CompletionStackViewModel {
    let mediaType: MediaType
    let title: String
    let description: String
    let buttonTitle: String
    let buttonHandler: Constants.Typealias.VoidHandler

    lazy var actionButtonSetupModel: GradientedButtonModel = {
        return GradientedButtonModel(title: buttonTitle,
                                     hasBorders: false,
                                     isActive: true) { [ weak self ] in
            self?.buttonHandler()
        }
    }()

    init(mediaType: MediaType,
         title: String,
         description: String,
         buttonTitle: String,
         buttonHandler: @escaping Constants.Typealias.VoidHandler) {
        self.mediaType = mediaType
        self.title = title
        self.description = description
        self.buttonTitle = buttonTitle
        self.buttonHandler = buttonHandler
    }
}

extension CompletionStackViewModel {
    enum MediaType {
        case image(String)
        case animation(String)
    }
}
