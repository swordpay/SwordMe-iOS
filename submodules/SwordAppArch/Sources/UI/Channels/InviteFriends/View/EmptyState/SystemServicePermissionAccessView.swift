//
//  SystemServicePermissionAccessView.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 09.02.23.
//

import UIKit

final class SystemServicePermissionAccessView: SetupableView {
    // MARK: - IBOutlets
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var errorIconImageView: UIImageView!
    @IBOutlet private weak var goToSettingsButton: UIButton!
    @IBOutlet private weak var closeButton: UIButton!
    
    // MARK: - Properties
    
    private var model: SystemServicePermissionAccessViewModel!
    
    // MARK: - Setup UI
    
    func setup(with model: SystemServicePermissionAccessViewModel) {
        self.model = model
        
        titleLabel.text = model.systemService.title
        descriptionLabel.text = model.systemService.description
        
        closeButton.isHidden = !model.hasCloseButton
        errorIconImageView.image = UIImage(named: model.systemService.iconName)
        
        goToSettingsButton.setTitle(Constants.Localization.Channels.goToSettings, for: .normal)
    }
    
    // MARK: - Actions
    
    @IBAction private func goToSettings() {
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
    }
    
    @IBAction private func closeSettings() {
        model.closeButtonActionPublisher.send(())
    }
}
