//
//  UIFont+Addition.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 09.05.23.
//

import UIKit

extension UIFont {
    func withWeight(_ weight: UIFont.Weight) -> UIFont {
        let newDescriptor = fontDescriptor.addingAttributes([.traits: [
            UIFontDescriptor.TraitKey.weight: weight]
                                                            ])
        return UIFont(descriptor: newDescriptor, size: pointSize)
    }
}
