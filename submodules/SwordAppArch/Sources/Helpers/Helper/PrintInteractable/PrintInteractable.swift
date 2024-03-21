//
//  PrintInteractable.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 04.04.23.
//

import UIKit
import SafariServices

public protocol PrintInteractable: NSObject  {
    var isPrintingAvailable: Bool { get }
    func print(image: UIImage)
}

public extension PrintInteractable where Self: UIViewController & UIPrintInteractionControllerDelegate {
    var isPrintingAvailable: Bool {
        return UIPrintInteractionController.isPrintingAvailable
    }

    func print(image: UIImage) {
        let printController = UIPrintInteractionController.shared

        printController.printingItem = image
        printController.present(animated: true)
    }
}
