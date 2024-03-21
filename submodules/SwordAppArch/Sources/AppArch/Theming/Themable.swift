//
//  Themable.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 13.04.22.
//

import UIKit

public protocol Themable {
    var theme: Theming { get }
}

extension Themable {
    public var theme: Theming {
        return ThemeProvider.currentTheme
    }
}

extension UIViewController: Themable { }

extension UIView: Themable { }
