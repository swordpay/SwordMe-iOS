//
//  BaseNavigation.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 24.04.22.
//

import UIKit

public enum NavigationType {
    case push(animated: Bool)
    case modal(
        presentationMode: UIModalPresentationStyle = .fullScreen,
        transitionStyle: UIModalTransitionStyle = .coverVertical,
        animated: Bool = true,
        completion: Constants.Typealias.ScreenPresentationCompletion? = nil
    )
}

public class BaseNavigation: Navigating {
    public weak var sourceViewController: UIViewController?

    public required init(sourceViewController: UIViewController) {
        self.sourceViewController = sourceViewController
    }

    @discardableResult
    public func goTo(_ destination: Destinationing) -> UIViewController? {
        guard let sourceViewController = sourceViewController else {
            print("sourceViewController is nil")

            return nil
        }

        let navigationType = destination.navigationType
        let controller = destination.viewController

        switch navigationType {
        case .push(let animated):
            sourceViewController.navigationController?.pushViewController(controller, animated: animated)
        case .modal(let modalPresentationStyle,let transitionStyle, let animated, let completion):
            if let delegate = sourceViewController as? UIAdaptivePresentationControllerDelegate {
                controller.presentationController?.delegate = delegate
            }
            controller.modalPresentationStyle = modalPresentationStyle
            controller.modalTransitionStyle = transitionStyle
            sourceViewController.present(controller, animated: animated, completion: completion)
        }

        removedCachedDestination(destination)
        return controller
    }
    
    private func removedCachedDestination(_ destination: Destinationing) {
        if let channelDestination = destination as? ChannelsDestination {
            ChannelsDestinationProvider.removeCachedViewControlelrs(for: channelDestination)
        } else if let cryptoDestination = destination as? CryptoAccountDestination {
            CryptoAccountDestinationProvider.removeCachedViewControlelrs(for: cryptoDestination)
        }
    }
}
