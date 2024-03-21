//
//  GradientedColorProvider.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 05.12.22.
//

import UIKit

final class GradientedColorProvider {
    static func gradientColor(from colors: [UIColor], in bounds: CGRect) -> UIColor {
        let layer = prepareGradientLayer(with: colors, in: bounds)
        
        UIGraphicsBeginImageContext(bounds.size)
        guard let context = UIGraphicsGetCurrentContext() else { return ThemeProvider.currentTheme.colors.gradientDarkBlue }
        layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        guard let image else { return ThemeProvider.currentTheme.colors.gradientDarkBlue }

        return UIColor(patternImage: image)
    }
    
    private static func prepareGradientLayer(with colors: [UIColor], in bounds: CGRect) -> CAGradientLayer {
        let gradient = CAGradientLayer()
        let cgColors = colors.map { $0.cgColor }

        gradient.frame = bounds
        gradient.colors = cgColors
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)

        return gradient
    }
}
