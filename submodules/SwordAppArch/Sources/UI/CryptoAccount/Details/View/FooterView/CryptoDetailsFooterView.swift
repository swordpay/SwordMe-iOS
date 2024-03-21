//
//  CryptoDetailsFooterView.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 09.03.23.
//

import UIKit

final class CryptoDetailsFooterView: SetupableView {
    // MARK: - IBOutlets
    
    @IBOutlet private weak var buyButtonHolderView: UIView!
    @IBOutlet private weak var sellButtonHolderView: UIView!
    
    // MARK: - Properties

    private var model: CryptoDetailsFooterViewModel!
    
    // MARK: - Setup UI
    
    func setup(with model: CryptoDetailsFooterViewModel) {
        self.model = model
        
        setupSellButton()
        setupGradientedButton(with: model.buyButtonViewModel, holderView: buyButtonHolderView)
    }
    
    private func setupSellButton() {
        guard model.canSell else {
            sellButtonHolderView.isHidden = true
            
            return
        }
        
        sellButtonHolderView.isHidden = false
        setupGradientedButton(with: model.sellButtonViewModel, holderView: sellButtonHolderView)
    }

    private func setupGradientedButton(with model: GradientedButtonModel, holderView: UIView) {
        let gradientedButton = GradientedButton()
        
        gradientedButton.translatesAutoresizingMaskIntoConstraints = false
        gradientedButton.setup(with: model)
        
        NSLayoutConstraint.activate([
            gradientedButton.heightAnchor.constraint(equalToConstant: 43)
        ])

        holderView.addSubview(gradientedButton)
        gradientedButton.addBorderConstraints(constraintSides: .all)
    }
}
