//
//  UIApplication+Addition.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 21.06.22.
//

import UIKit

extension UIApplication {
    public var mainWindow: UIWindow? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return nil }
        
        return window
    }

    var appVersion: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    }

    public func rootViewController() -> UIViewController? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else { return nil }

        return rootViewController
    }

    public func topMostViewController(base: UIViewController? = UIApplication.shared.rootViewController()) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topMostViewController(base: nav.visibleViewController)
        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return topMostViewController(base: selected)

        } else if let presented = base?.presentedViewController {
            return topMostViewController(base: presented)
        }

        return base
    }
    
    public func changeRootViewController(_ controller: UIViewController,
                                  animated: Bool = true,
                                  completion: Constants.Typealias.CompletioHandler<Bool>? = nil) {
        guard let mainWindow else {
            return
        }

        mainWindow.rootViewController = controller
        
        let options: UIView.AnimationOptions = .transitionCrossDissolve
        let duration: TimeInterval = 0.3

        UIView.transition(with: mainWindow, duration: duration, options: options, animations: {}, completion: completion)
    }
}
