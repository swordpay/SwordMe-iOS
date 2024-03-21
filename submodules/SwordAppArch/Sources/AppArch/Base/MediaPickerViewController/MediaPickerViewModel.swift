//
//  MediaPickerViewModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 06.05.22.
//

import UIKit
import Combine

final class MediaPickerViewModel: BaseViewModel<Void> {
    var sourceType: UIImagePickerController.SourceType
    let mediaSelectionHandler: Constants.Typealias.CompletioHandler<MediaType>

    var emptyStateViewModel: SystemServicePermissionAccessViewModel = .init(systemService: .camera,
                                                                            hasCloseButton: true)

    init(sourceType: UIImagePickerController.SourceType, mediaSelectionHandler: @escaping Constants.Typealias.CompletioHandler<MediaType>) {
        self.sourceType = sourceType
        self.mediaSelectionHandler = mediaSelectionHandler

        super.init(inputs: ())
    }
}
