//
//  ChannelsActionsBottomView.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 06.04.23.
//

import UIKit

public final class ChannelsActionsBottomView: SetupableView {
    // MARK: - IBOutlets
    
    @IBOutlet private weak var sendButton: RoundButton!
    @IBOutlet private weak var additionalButtonHolderView: UIView!
    @IBOutlet private weak var additionalButtonTitleLabel: UILabel!
    
    @IBOutlet private weak var holderViewTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var holderViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var actionsViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Properties

    private var model: ChannelsActionsBottomViewModel!
    
    // MARK: - Setup UI
    
    public func setup(with model: ChannelsActionsBottomViewModel) {
        self.model = model
        
        actionsViewHeightConstraint.constant = ComponentSizeProvider.sendOrReqeustButtonHeight.size
        setupUI()
        setupAdditionalButtonHolderView()
        setupButtonUI(sendButton, title: Constants.Localization.Common.send)
    }
    
    private func setupUI() {
        guard !model.isForChannels else {
            
            return
        }
        
        holderViewTopConstraint.constant = 7
        holderViewBottomConstraint.constant = 0
    }

    private func setupAdditionalButtonHolderView() {
        additionalButtonTitleLabel.text = Constants.Localization.Common.request
        additionalButtonTitleLabel.font = theme.fonts.font(style: .customButton, family: .poppins, weight: .semibold)
        additionalButtonHolderView.setCornerRadius(actionsViewHeightConstraint.constant / 2)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(additionalButtonTapHandler))
        
        additionalButtonHolderView.addGestureRecognizer(tapGesture)
        additionalButtonHolderView.isUserInteractionEnabled = true
    }
    
    private func setupButtonUI(_ button: RoundButton, title: String) {
        button.cornerRadius = button.frame.height / 2
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = theme.fonts.font(style: .sendOrRequestButton,
                                                   family: .poppins,
                                                   weight: .semibold)
    }
    
    private func setupShadow() {
        layer.shadowOffset = CGSize(width: 0, height: -4)
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.1
        layer.shadowColor = UIColor.black.withAlphaComponent(6).cgColor
    }

    // MARK: - Actions
    
    @IBAction
    private func sendButtonTouchUp(_ sender: UIButton) {
        model.payOrRequestButtonPublisher.send(())
    }
    
    @objc
    private func additionalButtonTapHandler() {
        model.payOrRequestButtonPublisher.send(())
    }
}
