//
//  DefaultFonts.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 13.04.22.
//

import UIKit

final class DefaultFonts: AppFonts {
    func regular(ofSize size: CGFloat, family: FontFamily) -> UIFont {
        return font(for: family, weight: .regular, size: size)
    }

    func medium(ofSize size: CGFloat, family: FontFamily) -> UIFont {
        return font(for: family, weight: .medium, size: size)
    }

    func semibold(ofSize size: CGFloat, family: FontFamily) -> UIFont {
        return font(for: family, weight: .semibold, size: size)
    }

    func bold(ofSize size: CGFloat, family: FontFamily) -> UIFont {
        return font(for: family, weight: .bold, size: size)
    }

    func robotoSemibold(ofSize size: CGFloat) -> UIFont {
        return font(for: .roboto, weight: .semibold, size: size)
    }

    func rubikItalic(ofSize size: CGFloat) -> UIFont {
        return font(for: .rubik, weight: .italic, size: size)
    }

    func font(style: FontStyle, family: FontFamily, weight: FontWeight) -> UIFont {
        return UIFont(name: "\(family.rawValue)-\(weight.rawValue)", size: style.size) ?? .systemFont(ofSize: style.size)
    }

    private func font(for family: FontFamily, weight: FontWeight, size: CGFloat) -> UIFont {
        return UIFont(name: "\(family.rawValue)-\(weight.rawValue)", size: size) ?? .systemFont(ofSize: size)
    }
}
