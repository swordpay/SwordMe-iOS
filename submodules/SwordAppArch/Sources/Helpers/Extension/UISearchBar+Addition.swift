//
//  UISearchBar+Addition.swift
//  SwordAppArch
//
//  Created by Tigran Simonyan on 23.10.23.
//

import UIKit

public extension UISearchBar {
    func setPlaceHolder(text: String?, animated: Bool = false) {
        self.layoutIfNeeded()
        self.placeholder = text
        
        let offset = UIOffset(horizontal: 0, vertical: 0)
        self.setPositionAdjustment(offset, for: .search)
        if animated {
            UIView.animate(withDuration: 0.2) {
                self.layoutIfNeeded()
            }
        }
    }
}
