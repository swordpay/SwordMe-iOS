//
//  UIScreen+Addition.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 28.05.23.
//

import UIKit

extension UIScreen {
    static var hasSmallScreen: Bool {
        guard let root = UIApplication.shared.rootViewController() else { return false }
        return root.view.frame.height < 700
    }
}

