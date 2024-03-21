//
//  RecentChannelItemCell.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 27.03.23.
//

import UIKit

final class RecentChannelItemCell: SetupableCollectionCell {
    // MARK: - IBOutlets
    
    @IBOutlet private weak var imageHolderView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    
    // MARK: - Peropertis
    
    private var model: RecentChannelItemCellModel!
    
    // MARK: - Setup UI
    
    func setup(with model: RecentChannelItemCellModel) {
        self.model = model
        
        titleLabel.text = model.channelItem.presentableName
        setupProfileImageView()
        model.prepareChannelImagePhoto()
    }
    
    private func setupProfileImageView() {
        guard let view = TextPlaceholderedImageView.loadFromNib() else { return }
        
        view.setup(with: model.channelImageSetupModel)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        imageHolderView.addSubview(view)
        view.addBorderConstraints(constraintSides: .all)
        imageHolderView.setCornerRadius(imageHolderView.frame.height / 2)
    }
}
