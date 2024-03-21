//
//  BackDestination.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 24.04.22.
//

import UIKit
import Display

public enum BackDestination: CommonDestinationing {
    case dismissToRoot(animated: Bool, completion: (() -> Void)?)
    case dismiss(animated: Bool, completion: (() -> Void)?)
    case popToRoot(animated: Bool)
    case popToVC(viewController: UIViewController, animated: Bool)
    case pop(animated: Bool)
}

extension BackDestination {
    public func handleNavigation(sourceViewController: UIViewController?) -> UIViewController? {
        guard let sourceViewController = sourceViewController else {
            print("sourceViewController is nil")

            return nil
        }

        switch self {
        case let .dismissToRoot(animated, completion):
            UIApplication.shared.rootViewController()?.dismiss(animated: animated, completion: completion)
            
            return nil
        case let .dismiss(animated, completion):
            sourceViewController.dismiss(animated: animated, completion: completion)
            
            return nil
        case .popToRoot(let animated):
            if let telegramNavController = sourceViewController.navigationController as? NavigationController {
                telegramNavController.popToRoot(animated: true)
                return telegramNavController.viewControllers.first
            } else {
                return sourceViewController.navigationController?.popToRootViewController(animated: animated)?.first
            }
        case let .popToVC(vc, animated):
            return sourceViewController.navigationController?.popToViewController(vc, animated: animated)?.first
        case .pop(let animated):
            return sourceViewController.navigationController?.popViewController(animated: animated)
        }
    }
}
