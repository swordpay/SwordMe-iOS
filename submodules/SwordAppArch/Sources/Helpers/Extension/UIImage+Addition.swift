//
//  UIImage+Addition.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 08.12.22.
//

import UIKit

extension UIImage {
    public func correctlyOrientedImage() -> UIImage {
        guard imageOrientation != .up else { return self }

        let defaultHeight: CGFloat = 640
        let newWidth  = defaultHeight / (size.height / size.width)
        let newSize = CGSize(width: newWidth, height: defaultHeight)

        UIGraphicsBeginImageContextWithOptions(newSize, false, scale)
        draw(in: CGRect(origin: .zero, size: newSize))
        let normalizedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return normalizedImage
    }
    
    public convenience init?(imageName: String) {
        self.init(named: imageName, in: Constants.mainBundle, with: nil)
    }
}
