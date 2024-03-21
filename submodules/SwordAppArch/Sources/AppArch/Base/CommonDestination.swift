//
//  CommonDestination.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 22.12.22.
//

import UIKit
import Combine

public enum CommonDestination: Destinationing {
    case mediaPicker(UIImagePickerController.SourceType, Constants.Typealias.MediaSelectionHandler)
    case notificationPermission
    case qrCodePager(scanResultPublisher: PassthroughSubject<String?, Never>)
    case qrScanner(hasCloseButton: Bool,
                   resultPublisher: PassthroughSubject<String?, Never>)
    case myQRCode(String?)
    case bottomSheet
    
    public var viewController: UIViewController {
        switch self {
        case .mediaPicker(let sourceType, let handler):
            return ViewControllerProvider.MediaPicker.pickerController(with: sourceType,
                                                                       mediaSelectionHandler: handler)
        case .notificationPermission:
            return ViewControllerProvider.MultiActionedInfo.notificationPermission
        case .qrCodePager(let scanResultPublisher):
            return ViewControllerProvider.Common.qrCodePager(scanResultPublisher: scanResultPublisher)
        case .qrScanner(let hasCloseButton, let resultPublisher):
            return ViewControllerProvider.Common.qrScanner(hasCloseButton: hasCloseButton, resultPublisher: resultPublisher)
        case .myQRCode(let username):
            return ViewControllerProvider.Common.myQRCode(username: username)
        case .bottomSheet:
            return ViewControllerProvider.Common.bottomSheet
        }
    }

    public var navigationType: NavigationType {
        switch self {
        case .myQRCode:
            return .modal(presentationMode: .pageSheet)
        case .bottomSheet:
            return .modal(presentationMode: .pageSheet, transitionStyle: .coverVertical, animated: true, completion: nil)
        case .mediaPicker:
            return .modal(presentationMode: .overFullScreen, animated: true, completion: nil)
        default:
            return .modal(presentationMode: .fullScreen, animated: true, completion: nil)
        }
    }
}
