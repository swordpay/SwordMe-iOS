//
//  MediaPickerPresenter.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 22.12.22.
//

import UIKit
import Display

protocol MediaPickerPresenter: NSObject {
    var navigator: Navigating { get }
    
    func selectPhoto(isExistingOne: Bool, handler: @escaping Constants.Typealias.MediaSelectionHandler)
}

extension MediaPickerPresenter {
    func selectPhoto(isExistingOne: Bool, handler: @escaping Constants.Typealias.MediaSelectionHandler) {
        isExistingOne ? showProfileImageEditOptionsAlert(handler: handler) : showProfileImageUploadingTypeAlert(handler: handler)
    }
    
    private func showProfileImageEditOptionsAlert(handler: @escaping Constants.Typealias.MediaSelectionHandler) {
        let uploadAction = AlertModel.ButtonType.dynamic(title: Constants.Localization.Common.upload,
                                                         style: .default,
                                                         tag: 0)
        let removeAction = AlertModel.ButtonType.dynamic(title: Constants.Localization.Common.remove,
                                                         style: .destructive,
                                                         tag: 1)
        let alertModel = AlertModel(title: Constants.Localization.Common.photoEditOptionAlertTitle,
                                    message: Constants.Localization.Common.photoEditOptionAlertMessage,
                                    preferredStyle: .actionSheet, actions: [uploadAction, removeAction, .cancel(style: .cancel)], animated: true)

        navigator.goTo(AlertDestination.alert(model: alertModel, presentationCompletion: nil, actionCompletion: { [ weak self ] type in
            switch type {
            case .dynamic(_, _, _,let tag):
                if tag == 0 {
                    self?.showProfileImageUploadingTypeAlert(handler: handler)
                } else {
                    handler(.none)
                }
            default:
                return
            }
        }))
    }

    private func showProfileImageUploadingTypeAlert(handler: @escaping Constants.Typealias.MediaSelectionHandler) {
        let cameraAction = AlertModel.ButtonType.dynamic(title: Constants.Localization.Common.camera,
                                                         style: .default,
                                                         tag: 0)
        let galleryAction = AlertModel.ButtonType.dynamic(title: Constants.Localization.Common.gallery,
                                                         style: .default,
                                                         tag: 1)
        var actions: [AlertModel.ButtonType] = [galleryAction]
        
        if UIImagePickerController.isCameraDeviceAvailable(.rear) {
            actions.append(cameraAction)
        }

        actions.append(.cancel(style: .cancel))

        let alertModel = AlertModel(title: Constants.Localization.Common.uploadPhoto,
                                    message: Constants.Localization.Common.uploadPhotoType,
                                    preferredStyle: .actionSheet, actions: actions, animated: true)

        navigator.goTo(AlertDestination.alert(model: alertModel, presentationCompletion: nil, actionCompletion: { [ weak self ] type in
            switch type {
            case .dynamic(_, _, _,let tag):
                if tag == 0 {
                    self?.handleCamera(handler: handler)
                } else {
                    self?.handleGallery(handler: handler)
                }
            default:
                return
            }
        }))
    }
    
    // MARK: - Photo Upload Handlers

    private func handleCamera(handler: @escaping Constants.Typealias.MediaSelectionHandler) {
        navigator.goTo(CommonDestination.mediaPicker(.camera, handler))
    }

    private func handleGallery(handler: @escaping Constants.Typealias.MediaSelectionHandler) {
        navigator.goTo(CommonDestination.mediaPicker(.photoLibrary, handler))
    }
}
