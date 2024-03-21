//
//  MediaPickerViewControllerAssembly.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 06.05.22.
//

import UIKit
import Swinject

final class MediaPickerViewControllerAssembly: Assembly {
    let sourceType: UIImagePickerController.SourceType
    let mediaSelectionHandler: Constants.Typealias.CompletioHandler<MediaType>

    init(sourceType: UIImagePickerController.SourceType,
         mediaSelectionHandler: @escaping Constants.Typealias.CompletioHandler<MediaType>) {
        self.sourceType = sourceType
        self.mediaSelectionHandler = mediaSelectionHandler
    }

    func assemble(container: Container) {
        let sourceType = sourceType
        let mediaSelectionHandler = mediaSelectionHandler

        container.register(MediaPickerViewModel.self) { _ in
            let viewModel = MediaPickerViewModel(sourceType: sourceType, mediaSelectionHandler: mediaSelectionHandler)

            return viewModel
        }

        container.register(MediaPickerViewController.self) { resolver in
            let viewModel = resolver.resolve(MediaPickerViewModel.self)!
            let viewController = MediaPickerViewController(viewModel: viewModel)

            return viewController
        }
    }
}
