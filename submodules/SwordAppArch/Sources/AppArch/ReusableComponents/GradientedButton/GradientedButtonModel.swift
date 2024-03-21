//
//  GradientedButtonModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 27.06.22.
//

import UIKit
import Combine

public final class GradientedButtonModel {
    let title: String
    let hasBorders: Bool
    let isActive: CurrentValueSubject<Bool, Never>
    let action: Constants.Typealias.VoidHandler
    let style: Style
    let font: UIFont?

    var gradientColors: [UIColor] {
        let colors = ThemeProvider.currentTheme.colors
        switch style {
        case .default:
            return [colors.gradientDarkBlue,
                    colors.gradientDarkBlue]
        case .light:
            return [colors.mainWhite,
                    colors.mainWhite]
        case .destructive:
            return [colors.mainRed,
                    colors.mainRed]
        }
    }
    
    public init(title: String, font: UIFont? = nil, hasBorders: Bool, isActive: Bool, style: Style = .default, action: @escaping Constants.Typealias.VoidHandler) {
        self.title = title
        self.font = font
        self.hasBorders = hasBorders
        self.isActive = CurrentValueSubject(isActive)
        self.style = style
        self.action = action
    }
}

extension GradientedButtonModel {
    public enum Style {
        case `default`
        case light
        case destructive
    }
}
