//
//  Destinationing.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 24.04.22.
//

import UIKit

public protocol Destinationing {
    var viewController: UIViewController { get }
    var navigationType: NavigationType { get }
}

public protocol CommonDestinationing {
    @discardableResult
    func handleNavigation(sourceViewController: UIViewController?) -> UIViewController?
}
