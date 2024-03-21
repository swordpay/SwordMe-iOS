//
//  AddNewChannelView.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 21.12.22.
//

import UIKit

final class AddNewChannelView: SetupableView {
    // MARK: - IBOutlets
    @IBOutlet private weak var grabberView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var directMessageButton: UIButton!
    @IBOutlet private weak var groupChannelButton: UIButton!
    
    // MARK: - Properties
    
    private var model: AddNewChannelViewModel!
    
    // MARK: - Setup UI
    
    func setup(with model: AddNewChannelViewModel) {
        self.model = model
        
        titleLabel.text = Constants.Localization.Channels.createNewChannel
        grabberView.setCornerRadius(2)
        
        setupButtons()
    }
    
    private func setupButtons() {
        directMessageButton.setTitle(Constants.Localization.Channels.directMessage, for: .normal)
        groupChannelButton.setTitle(Constants.Localization.Channels.groupChannel, for: .normal)
        
        setupGradientTitledButton(directMessageButton)
        setupGradientTitledButton(groupChannelButton)
    }

    private func setupGradientTitledButton(_ button: UIButton) {
        lazy var colors = [theme.colors.gradientLightBlue, theme.colors.gradientDarkBlue]
        let color = GradientedColorProvider.gradientColor(from: colors,
                                                          in: button.titleLabel?.bounds ?? bounds)
        
        button.setTitleColor(color, for: .normal)
    }

    // MARK: - Actions
    
    @IBAction private func directMessageButtonTouchUp(_ sender: UIButton) {
        model.directMessageButtonPublisher.send(())
    }
    
    @IBAction private func groupChannelButtonTouchUp(_ sender: UIButton) {
        model.groupChannelButtonPublisher.send(())
    }
}
