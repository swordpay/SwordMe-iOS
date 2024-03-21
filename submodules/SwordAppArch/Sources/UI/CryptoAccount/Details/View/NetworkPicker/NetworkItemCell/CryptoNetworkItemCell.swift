//
//  CryptoNetworkItemCell.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 29.05.23.
//

import UIKit

final class CryptoNetworkItemCell: SetupableTableViewCell {
    // MARK: - IBOutlets
    
    @IBOutlet private weak var roundedBackgroundView: UIView!
    @IBOutlet private weak var nameLabel: UILabel!
    
    // MARK: - Properties
    
    private var model: CryptoNetworkItemCellModel!
    
    // MARK: - Setup UI
    
    func setup(with model: CryptoNetworkItemCellModel) {
        self.model = model
        
        nameLabel.text = model.network.name
        roundedBackgroundView.setCornerRadius(10)
    }
}
