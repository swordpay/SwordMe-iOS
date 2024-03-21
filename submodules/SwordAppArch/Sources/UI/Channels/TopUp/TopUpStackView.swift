//
//  TopUpStackView.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 25.05.23.
//

import UIKit

final class TopUpStackView: SetupableStackView {
    // MARK: - IBOutlets
    
    @IBOutlet private weak var backgroundView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var topUpButtonHolderView: UIView!
    
    // MARK: - Properties
    
    private var model: TopUpStackViewModel!
    
    // MARK: - Setup UI
    
    func setup(with model: TopUpStackViewModel) {
        self.model = model
        
        backgroundView.setCornerRadius(8)
        titleLabel.text = Constants.Localization.Channels.topUpTitle
        setupTopUpButton()
    }

    private func setupTopUpButton() {
        let button = GradientedButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setup(with: model.topUpButtonViewModel)
        
        topUpButtonHolderView.addSubview(button)
        
        button.addBorderConstraints(constraintSides: .all)
        
        button.heightAnchor.constraint(equalToConstant: Constants.defaultButtonHeight).isActive = true
    }

    // MARK: - Actions
    
    @IBAction private func closeButtonTouchUp(_ sender: UIButton) {
        model.closeButtonTapHandler.send(())
    }
}
