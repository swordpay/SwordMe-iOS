//
//  Theming.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 13.04.22.
//

import Foundation
import UIKit

public protocol Theming {
    var colors: AppColors { get }
    var fonts: AppFonts { get }
}

public final class ThemeProvider {
    private static let queue = DispatchQueue(label: Constants.AppLabel.themeIdentifier,
                                             attributes: .concurrent)
    private static var theme: Theming = DefaultTheme()

    init() {}

    public static var currentTheme: Theming {
        queue.sync {
            return theme
        }
    }

    static func updateAppTheme(newTheme: Theming) {
        queue.async(flags: .barrier) {
            theme = newTheme
        }
    }
}
