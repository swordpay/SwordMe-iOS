//
//  ChannelsEmptyStateView.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 20.12.22.
//

import UIKit

final class ChannelsEmptyStateView: SetupableView {

    // MARK: - IBOutlets

    
    @IBOutlet private weak var mainHolderView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var inviteFriendsButton: UIButton!
    @IBOutlet private weak var imagesHolderStackView: UIStackView!
 
    // MARK: - Properties
    
    private var model: ChannelsEmptyStateViewModel!
    
    // MARK: - Setup UI
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupMainHolderView()
    }

    func setup(with model: ChannelsEmptyStateViewModel) {
        self.model = model
        
        setupLabels()
        setupButtons()
        
        imagesHolderStackView.isHidden = UIScreen.hasSmallScreen
    }
    
    private func setupMainHolderView() {
        let shadowLayer: CAShapeLayer = CAShapeLayer()
        
        mainHolderView.layer.cornerRadius = 10
        shadowLayer.path = UIBezierPath(roundedRect: mainHolderView.bounds,
           cornerRadius: 10).cgPath
        shadowLayer.fillColor = backgroundColor?.cgColor
        shadowLayer.shadowColor = UIColor.darkGray.cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = CGSize(width: 4,
                                          height: 2)
        shadowLayer.shadowOpacity = 0.1
        shadowLayer.shadowRadius = 10
        mainHolderView.layer.insertSublayer(shadowLayer, at: 0)
        
        setNeedsLayout()
    }
    
    private func setupLabels() {
        let descriptionFontSize: CGFloat = UIScreen.hasSmallScreen ? 14 : 16

        titleLabel.text = Constants.Localization.Channels.emptyStateTitle
        descriptionLabel.text = Constants.Localization.Channels.emptyStateDescription        
        descriptionLabel.font = theme.fonts.regular(ofSize: descriptionFontSize, family: .poppins)
    }
    
    private func setupButtons() {
        inviteFriendsButton.setTitle(Constants.Localization.Channels.inviteFriendsTitle, for: .normal)
        
        inviteFriendsButton.titleLabel?.font = theme.fonts.semibold(ofSize: 14, family: .poppins)
        inviteFriendsButton.setTitleColor(theme.colors.textBlue, for: .normal)
    }
    
    // MARK: - Actions
 
    @IBAction private func inviteFriendsButtonTouchUp(_ sender: UIButton) {
        model.inviteFriendsPublisher.send(())
    }
}
