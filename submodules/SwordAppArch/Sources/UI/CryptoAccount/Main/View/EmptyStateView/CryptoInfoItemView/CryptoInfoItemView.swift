//
//  CryptoInfoItemView.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 10.02.23.
//

import UIKit
import Combine

final class CryptoInfoItemView: SetupableView {
    // MARK: - IBOutlets
    
    @IBOutlet private weak var amountLabel: UILabel!
    @IBOutlet private weak var abbreviationLabel: UILabel!
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var separatorView: UIView!
    
    // MARK: - Properties
    
    private var model: CryptoInfoItemViewModel!
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Setup UI
    
    func setup(with model: CryptoInfoItemViewModel) {
        self.model = model
        
        amountLabel.text = "£ \(model.cryptoModel.priceInEuro)"
        abbreviationLabel.text = model.cryptoModel.abbreviation
        separatorView.isHidden = !model.hasSeparator

        bindToCryptoIcon()
        model.prepareCryptoImageData()
    }
    
    // MARK: - Binding
    
    private func bindToCryptoIcon() {
        model.cryptoIconDataPublisher
            .receive(on: RunLoop.main)
            .sink { [ weak self ] data in
                guard let data, let iconImage = UIImage(data: data) else {
                    self?.iconImageView.isHidden = true
                    
                    return
                    
                }

                self?.iconImageView.isHidden = false
                self?.iconImageView.image = iconImage
            }
            .store(in: &cancellables)
    }

}
