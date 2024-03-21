//
//  QRScannerStackViewModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 08.02.23.
//

import Combine
import Foundation

final class QRScannerStackViewModel {
    var resultPublisher: PassthroughSubject<String?, Never> = PassthroughSubject()
    var closeButtonActionPublisher: PassthroughSubject<Void, Never> = PassthroughSubject()
    
    var hasCloseButton: Bool
    
    init(hasCloseButton: Bool) {
        self.hasCloseButton = hasCloseButton
    }

    func prepareOverlayFrame(from frame: CGRect, center: CGPoint) -> CGRect {
        let sideSize = frame.width * 0.75
        
        let originX = center.x - sideSize / 2
        let originY = center.y - sideSize / 2
        
        return CGRect(x: originX, y: originY, width: sideSize, height: sideSize)
    }
}
