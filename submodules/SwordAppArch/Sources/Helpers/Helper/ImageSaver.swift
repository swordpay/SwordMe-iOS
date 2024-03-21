//
//  ImageSaver.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 29.05.23.
//

import UIKit

final class ImageSaver: NSObject {
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }

    @objc
    func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        let title = "Save Image"
        let message = error == nil ? "Image has been saved successfully" : "Image saving has been failed"
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(.init(title: "Ok", style: .default))
        
        UIApplication.shared.topMostViewController()?.present(alertController, animated: true)
    }
}

final class ScreenshotCapture {
    static func captureScreenShot(of view: UIView) -> UIImage? {
        let layer = view.layer
        let scale = UIScreen.main.scale
        // Creates UIImage of same size as view
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return screenshot
    }
}
