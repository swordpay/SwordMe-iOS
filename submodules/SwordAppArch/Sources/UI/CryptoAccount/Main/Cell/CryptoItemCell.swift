//
//  CryptoItemCell.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 10.02.23.
//

import UIKit
import Combine

public final class CryptoItemCell: SetupableTableViewCell {
    // MARK: - IBOutlets
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var iconBackgroundView: UIView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var infoLabel: UILabel!
    @IBOutlet private weak var priceInEuroLabel: UILabel!
    @IBOutlet private weak var oscillationLabel: UILabel!

    // MARK: - Properties
    
    private var model: CryptoItemCellModel!
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Lifecycle Methods
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        
        iconImageView.image = nil
        iconImageView.alpha = 0
        iconBackgroundView.backgroundColor = theme.colors.lightBlue2
        iconImageView.backgroundColor = theme.colors.backgroundDarkGray
        model.cancelPaymentMethodIconDownloading()
        cancellables = []
    }

    // MARK: - Setup UI

    public func setup(with model: CryptoItemCellModel) {
        self.model = model
        
        iconBackgroundView.setCornerRadius(iconBackgroundView.frame.height / 2)
        iconBackgroundView.backgroundColor = theme.colors.lightBlue2
        
        nameLabel.text = model.cryptoModel.name
        infoLabel.text = model.cryptoInfo
        priceInEuroLabel.text = model.priceInEuro
        
        setupOscillationLabel(oscillationByPercent: model.cryptoModel.oscillationByPercent.value)
        setupCryptoIconImageView()
        
        bindToCryptoPrice()
        bindToCryptoPriceInEuro()
        bindToOscillationByPercent()
    }
    
    private func setupCryptoIconImageView() {
        iconImageView.alpha = 0
        iconImageView.contentMode = .scaleAspectFill
        iconImageView.setCornerRadius(iconImageView.frame.height / 2)
        if let data = model.cryptoIconDataPublisher.value,
           let image = UIImage(data: data) {
            iconImageView.image = image
            iconImageView.alpha = 1
            iconImageView.backgroundColor = .clear
            model.cachedImage = data
        } else {
            bindToCryptoIcon()
            model.prepareCryptoImageData()
        }
    }

    private func setupOscillationLabel(oscillationByPercent: String) {
        guard let doubledOscillation = Double(oscillationByPercent) else { return }

        let isOscillationNegative = oscillationByPercent.contains("-")
        let color = isOscillationNegative ? theme.colors.mainRed2 : theme.colors.mainGreen
        
        oscillationLabel.textColor = color
        oscillationLabel.text = "\(doubledOscillation.bringToPresentableFormat()) %"
    }

    // MARK: - Binding
    
    private func bindToCryptoIcon() {
        model.cryptoIconDataPublisher
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink { [ weak self ] data in
                self?.iconImageView.backgroundColor = .clear
                guard let data,
                      let iconImage = UIImage(data: data) else {
                    self?.animateImageViewAlpha(image: UIImage(imageName: Constants.AssetName.CryptoAccount.cryptoIconPlaceholder))
                    
                    return
                }

                self?.animateImageViewAlpha(image: iconImage)
            }
            .store(in: &cancellables)
    }
    
    private func animateImageViewAlpha(image: UIImage?) {
        iconImageView.image = image
        
        UIView.animate(withDuration: 0.5) {
            self.iconImageView.alpha = 1
        }
    }
    
    private func bindToCryptoPrice() {
        model.cryptoModel.accountInfo?.balance
            .sink { [ weak self ] _ in
                self?.infoLabel.text = self?.model.cryptoInfo
            }
            .store(in: &cancellables)
    }

    private func bindToCryptoPriceInEuro() {
        model.cryptoModel.priceInEuro
            .receive(on: RunLoop.main)
            .sink { [ weak self ] priceInEuro in
                self?.priceInEuroLabel.text = self?.model.priceInEuro
            }
            .store(in: &cancellables)
    }
    
    private func bindToOscillationByPercent() {
        model.cryptoModel.oscillationByPercent
            .receive(on: RunLoop.main)
            .sink { [ weak self ] oscillationByPercent in
                self?.setupOscillationLabel(oscillationByPercent: oscillationByPercent)
            }
            .store(in: &cancellables)
    }
}
