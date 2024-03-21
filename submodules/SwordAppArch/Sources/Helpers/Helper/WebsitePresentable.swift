//
//  WebsitePresentable.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 11.05.22.
//

import UIKit
import Display
import SafariServices

public protocol SafariWebsitePresentable: NSObject  {
    func openWebsite(path: String)
}

extension SafariWebsitePresentable where Self: UIViewController {
    public func openWebsite(path: String) {
        if let url = URL(string: path) {
            UIApplication.shared.open(url)
        }
    }
}

public protocol InAppWebsitePresentable {
    func openWebsite(path: String)
}

extension InAppWebsitePresentable where Self: UIViewController & SFSafariViewControllerDelegate {
    public func openWebsite(path: String) {
        if let url = URL(string: path) {
            let config = SFSafariViewController.Configuration()
            
            let vc = SFSafariViewController(url: url, configuration: config)
            vc.delegate = self
            vc.preferredControlTintColor = theme.colors.textBlue
            UIApplication.shared.rootViewController()?.present(vc, animated: true)
        }
    }
}
