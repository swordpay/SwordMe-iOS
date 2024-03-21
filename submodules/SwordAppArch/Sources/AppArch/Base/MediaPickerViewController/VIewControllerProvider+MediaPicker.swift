//
//  VIewControllerProvider+MediaPicker.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 06.05.22.
//

import UIKit
import Swinject

extension ViewControllerProvider {
    enum MediaPicker {
        static func pickerController(with sourceType: UIImagePickerController.SourceType,
                                     mediaSelectionHandler: @escaping Constants.Typealias.CompletioHandler<MediaType>) -> MediaPickerViewController {
            let assembler = Assembler([MediaPickerViewControllerAssembly(sourceType: sourceType,
                                                                         mediaSelectionHandler: mediaSelectionHandler)])

            return assembler.resolver.resolve(MediaPickerViewController.self)!
        }
    }
}
