//
//  CryptoShimmerItemView.swift
//  SwordAppArch
//
//  Created by Tigran Simonyan on 01.12.23.
//

import UIKit

final class CryptoShimmerItemView: SetupableView {
    // MARK: - IBOutlets
    
    @IBOutlet private weak var cryptoIconPlaceholderView: UIView!
    @IBOutlet private weak var namePlaceholderView: UIView!
    @IBOutlet private weak var amountPlaceholderView: UIView!
    @IBOutlet private weak var pricePlaceholderView: UIView!
    @IBOutlet private weak var percentPlaceholderView: UIView!

    func setup(with model: ()) {
        cryptoIconPlaceholderView.setCornerRadius(20)
        namePlaceholderView.setCornerRadius(4)
        amountPlaceholderView.setCornerRadius(4)
        pricePlaceholderView.setCornerRadius(4)
        percentPlaceholderView.setCornerRadius(4)
    }
    
    func animate() {
        cryptoIconPlaceholderView.startShimmerAnimation()
        namePlaceholderView.startShimmerAnimation()
        amountPlaceholderView.startShimmerAnimation()
        pricePlaceholderView.startShimmerAnimation()
        percentPlaceholderView.startShimmerAnimation()
    }
}
