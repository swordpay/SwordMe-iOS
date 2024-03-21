//
//  CryptoPickerItemCell.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 22.03.23.
//

import UIKit
import Combine
import Kingfisher

final class CryptoPickerItemCell: SetupableTableViewCell {
    // MARK: - IBOutlets
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var coinLabel: UILabel!
    @IBOutlet private weak var iconImageView: UIImageView!
    
    // MARK: - Propertis
    
    private var model: CryptoPickerItemCellModel!
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Lifecycle Methods
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        iconImageView.image = nil
        iconImageView.backgroundColor = theme.colors.backgroundDarkGray
        cancellables = []
    }

    // MARK: - Setup UI
    
    func setup(with model: CryptoPickerItemCellModel) {
        self.model = model
        
        nameLabel.text = model.cryptoMainInfo.name
        coinLabel.text = model.info
        
        setupCoinIconImageView()
    }

    private func setupCoinIconImageView() {
        let defaultIcon = UIImage(imageName: Constants.AssetName.CryptoAccount.cryptoIconPlaceholder)
        
        iconImageView.layer.borderColor = theme.colors.backgroundGray.cgColor
        iconImageView.layer.borderWidth = 1
        iconImageView.backgroundColor = theme.colors.backgroundDarkGray
        iconImageView.setCornerRadius(iconImageView.frame.height / 2)
        iconImageView.contentMode = .scaleAspectFit

        guard let flagUrl = model.iconURL else {
            iconImageView.image = defaultIcon
 
            return
        }
        
        let processor = ResizingImageProcessor(referenceSize: CGSize(width: 120, height: 120))

        iconImageView.backgroundColor = .clear
        iconImageView.isHidden = false
        iconImageView.kf.setImage(with: flagUrl, placeholder: defaultIcon, options: [.processor(processor)])
    }
}
