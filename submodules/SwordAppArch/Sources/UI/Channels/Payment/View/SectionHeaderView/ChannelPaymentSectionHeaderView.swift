//
//  ChannelPaymentSectionHeaderView.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 27.12.22.
//

import UIKit

final class ChannelPaymentSectionHeaderView: UITableViewHeaderFooterView, Setupable {

    // MARK: - IBOutlets
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var participantsSwitch: UISwitch!

    // MARK: - Properties
    
    private var model: ChannelPaymentSectionHeaderViewModel!
    
    // MARK: - Setup UI
    
    func setup(with model: ChannelPaymentSectionHeaderViewModel) {
        self.model = model

        setupBackgroundView()

        titleLabel.text = Constants.Localization.Channels.requestFrom
        descriptionLabel.text = Constants.Localization.Channels.everyoneInGroup
    }
    
    private func setupBackgroundView() {
        let view = UIView()
        
        view.backgroundColor = .white
        self.backgroundView = view
    }
    // MARK: - Actions
    
    @IBAction private func participantsSwitchValueDidChange(_ sender: UISwitch) {
        model.isRequestingFromEveryone.send(sender.isOn)
    }
}
