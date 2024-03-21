//
//  DraggerView.swift
//  SwordAppArch
//
//  Created by Tigran Simonyan on 14.03.24.
//

import UIKit

public final class DraggerView: SetupableView {
    // MARK: - IBOutlets
    
    @IBOutlet private weak var draggerView: UIView!
    
    // MARK: - Setup UI
    
    public func setup(with model: Void) {
        draggerView.setCornerRadius(draggerView.frame.height / 2)
    }
}
