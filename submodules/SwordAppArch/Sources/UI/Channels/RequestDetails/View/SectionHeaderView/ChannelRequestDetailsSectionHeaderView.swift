//
//  ChannelRequestDetailsSectionHeaderView.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 29.12.22.
//

import UIKit

final class ChannelRequestDetailsSectionHeaderView: UITableViewHeaderFooterView, Setupable {
    // MARK: - IBOutlets
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var paymentReminderHolderStackView: UIStackView!
    @IBOutlet private weak var paymentInfoDescription: UILabel!
    @IBOutlet private weak var sendReminderButton: UIButton!
    
    // MARK: - Properties
    
    private var model: ChannelRequestDetailsSectionHeaderViewModel!
    
    // MARK: - Setup UI
    
    func setup(with model: ChannelRequestDetailsSectionHeaderViewModel) {
        self.model = model
        
        titleLabel.text = Constants.Localization.Channels.paymentDetails
        paymentInfoDescription.text = Constants.Localization.Channels.noPayment
        
        setupBackgroundView()
        setupReminderButton()
        paymentReminderHolderStackView.isHidden = model.hasPayment
    }
    
    private func setupBackgroundView() {
        let view = UIView()
        
        view.backgroundColor = .white
        backgroundView = view
    }
    
    private func setupReminderButton() {
        sendReminderButton.setTitle(Constants.Localization.Channels.sendReminder, for: .normal)
        sendReminderButton.setTitleColor(theme.colors.gradientDarkBlue, for: .normal)
        sendReminderButton.setCornerRadius()
        sendReminderButton.layer.borderWidth = 1
        sendReminderButton.layer.borderColor = theme.colors.gradientDarkBlue.cgColor
    }
    
    // MARK: - Actions
    
    @IBAction private func sendReminderButtonTouchUp(_ sender: UIButton) {
        model.sendReminderPublisher.send(())
    }
}
