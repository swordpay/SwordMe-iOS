//
//  Navigating.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 21.04.22.
//

import UIKit

public protocol Navigating {
    var sourceViewController: UIViewController? { get set }

    init(sourceViewController: UIViewController)

    @discardableResult
    func goTo(_ destination: Destinationing) -> UIViewController?
    @discardableResult
    func goTo(_ destination: CommonDestinationing) -> UIViewController?
}

extension Navigating {
    @discardableResult
    public func goTo(_ destination: CommonDestinationing) -> UIViewController? {
        return destination.handleNavigation(sourceViewController: sourceViewController)
    }
}
