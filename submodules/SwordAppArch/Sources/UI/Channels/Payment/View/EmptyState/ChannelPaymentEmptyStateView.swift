//
//  ChannelPaymentEmptyStateView.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 10.04.23.
//

import UIKit

final class ChannelPaymentEmptyStateView: SetupableView {
    // MARK: - IBOutlets
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var iconImageView: UIImageView!
    
    // MARK: - Properties
    
    private var model: ChannelPaymentEmptyStateViewModel!
    
    // MARK: - Setup UI
    
    func setup(with model: ChannelPaymentEmptyStateViewModel) {
        self.model = model
        
        titleLabel.text = Constants.Localization.GenericError.title
        descriptionLabel.text = Constants.Localization.PayOrRequest.emptyStateDescription
        
//        iconImageView.image = UIImage(imageName: Constants.AssetName.FiatAccount.emptyCards)
    }
}
