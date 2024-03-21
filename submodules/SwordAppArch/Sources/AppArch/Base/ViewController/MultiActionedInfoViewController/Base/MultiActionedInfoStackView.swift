//
//  MultiActionedInfoStackView.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 08.12.22.
//

import UIKit
import Combine

final class MultiActionedInfoStackView: SetupableStackView {
    // MARK: - IBOutlets
    
    @IBOutlet private weak var topDescriptionLabel: UILabel!
    @IBOutlet private weak var topDescriptionIconImageView: UIImageView!
    @IBOutlet private weak var bottomDescriptionLabel: UILabel!
    @IBOutlet private weak var mainIconImageView: UIImageView!
    @IBOutlet private weak var primaryButtonHolderView: UIView!
    @IBOutlet private weak var secondaryButton: UIButton!
    @IBOutlet private weak var privacyPolicyHolderView: UIView!

    @IBOutlet private weak var mainIconImageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var mainIconImageViewHeightConstraint: NSLayoutConstraint!

    @IBOutlet private weak var primaryButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var secondaryButtonHeightConstraint: NSLayoutConstraint!

    // MARK: - Properties
    
    private var model: MultiActionedInfoStackViewModel!
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Lifecycle Methods
    

    // MARK: - Setup UI
    
    func setup(with model: MultiActionedInfoStackViewModel) {
        self.model = model

        setupMainIconConstraints()
        mainIconImageView.image = UIImage(imageName: model.setupModel.mainIconName)

        primaryButtonHeightConstraint.constant = Constants.defaultButtonHeight
        secondaryButtonHeightConstraint.constant = Constants.defaultButtonHeight

        setupPrimaryButton()
        setupSecondaryButton()
        setupBottomDescription()
        setupTopDescriptionViews()
    }
    
    private func setupMainIconConstraints() {
        mainIconImageViewTopConstraint.priority = UIScreen.hasSmallScreen ? .required : .defaultLow
        mainIconImageViewHeightConstraint.priority = UIScreen.hasSmallScreen ? .defaultLow : .required
    }

    private func setupTopDescriptionViews() {
        topDescriptionLabel.font = theme.fonts.font(style: .smallText, family: .poppins, weight: .regular)
        if let topDescription = model.setupModel.topDescription {
            topDescriptionLabel.isHidden = false
            topDescriptionLabel.text = topDescription
        } else {
            topDescriptionLabel.isHidden = true
        }
        
        if let topDescriptionIcon = model.setupModel.topDescriptionIconName {
            topDescriptionIconImageView.isHidden = false
            topDescriptionIconImageView.image = UIImage(imageName: topDescriptionIcon)
        } else {
            topDescriptionIconImageView.isHidden = true
        }
    }
    
    private func setupBottomDescription() {
        guard let bottomDescription = model.setupModel.bottomDescription else {
            bottomDescriptionLabel.isHidden = true
            
            return
        }
        
        bottomDescriptionLabel.font = theme.fonts.font(style: .body, family: .poppins, weight: .regular)
        bottomDescriptionLabel.isHidden = false
        bottomDescriptionLabel.text = bottomDescription
    }

    private func setupPrimaryButton() {
        guard let primaryButtonViewModel = model.primaryButtonViewModel else {
            primaryButtonHolderView.isHidden = true
            
            return
        }

        let button = GradientedButton()
        
        button.setup(with: primaryButtonViewModel)
        button.translatesAutoresizingMaskIntoConstraints = false

        primaryButtonHolderView.addSubview(button)
        button.addBorderConstraints(constraintSides: .all)
        
        primaryButtonHolderView.isHidden = false
    }
    
    private func setupSecondaryButton() {
        guard model.setupModel.primaryButtonTitle != nil,
              let secondaryButtonTitle = model.setupModel.secondaryButtonTitle else {
            secondaryButton.isHidden = true
            
            return
        }

        secondaryButton.isHidden = false

        secondaryButton.setTitleColor(theme.colors.gradientDarkBlue, for: .normal)
        secondaryButton.setTitle(secondaryButtonTitle, for: .normal)
        secondaryButton.titleLabel?.numberOfLines = 2
        secondaryButton.titleLabel?.textAlignment = .center
    }

    //MARK: - Actions
    
    @IBAction private func secondaryButtonTouchUp(_ sender: UIButton) {
        model.secondaryButtonActionHandler.send(())
    }
}
