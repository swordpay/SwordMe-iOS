//
//  ChannelPaymnetAmountCryptoInfoView.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 22.05.23.
//

import UIKit
import Combine
import Kingfisher

final class ChannelPaymnetAmountCryptoInfoView: SetupableView {
    // MARK: - IBOutlets
    
    @IBOutlet private weak var holderBackgroundView: UIView!
    @IBOutlet private weak var cryptoNameLabel: UILabel!
    @IBOutlet private weak var amountLabel: UILabel!
    @IBOutlet private weak var cryptoIconImageView: UIImageView!
    
    // MARK: - Properties
    
    private var model: ChannelPaymnetAmountCryptoInfoViewModel!
    private var cancellables: Set<AnyCancellable> = []
 
    // MARK: - Setup UI
    
    func setup(with model: ChannelPaymnetAmountCryptoInfoViewModel) {
        self.model = model
        
        updateUI(cryptoModel: model.cryptoModel.value)
        holderBackgroundView.setCornerRadius(8)
        setupCoinIconImageView()
        
        bindToCryptoModel()
    }
    
    func updateUI(cryptoModel: ChannelPaymnetAmountViewModel.CryptoInfo?) {
        guard let cryptoModel else { return }

        cryptoNameLabel.text = "\(cryptoModel.selectedCoin.abbriviation)/EUR"
        amountLabel.text = "1\(cryptoModel.selectedCoin.abbriviation) = \(cryptoModel.price.bringToPresentableFormat())EUR"
        
        setupCoinIconImageView()
    }
    
    private func setupCoinIconImageView() {
        let defaultIcon = UIImage(imageName: Constants.AssetName.CryptoAccount.cryptoIconPlaceholder)
        
        cryptoIconImageView.layer.borderColor = theme.colors.textColor.cgColor
        cryptoIconImageView.layer.borderWidth = 1
        cryptoIconImageView.backgroundColor = theme.colors.backgroundDarkGray
        cryptoIconImageView.setCornerRadius(cryptoIconImageView.frame.height / 2)
        cryptoIconImageView.contentMode = .scaleAspectFit

        guard let flagUrl = model.iconURL else {
            cryptoIconImageView.image = defaultIcon
 
            return
        }
        
        let processor = ResizingImageProcessor(referenceSize: CGSize(width: 120, height: 120))

        cryptoIconImageView.backgroundColor = .clear
        cryptoIconImageView.isHidden = false
        cryptoIconImageView.kf.setImage(with: flagUrl, placeholder: defaultIcon, options: [.processor(processor)])
    }
    
    // MARK: - Bingind
    
    private func bindToCryptoModel() {
        model.cryptoModel
            .sink { [ weak self ] crypto in
                self?.updateUI(cryptoModel: crypto)
            }
            .store(in: &cancellables)
    }
}
