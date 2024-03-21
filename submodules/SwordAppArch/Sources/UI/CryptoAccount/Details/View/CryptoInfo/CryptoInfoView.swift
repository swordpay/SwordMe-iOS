//
//  CryptoInfoView.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 09.03.23.
//

import UIKit
import Combine

final class CryptoInfoView: SetupableView {
    // MARK: - IBOutlets
    
    @IBOutlet private weak var contentHolderStackView: UIStackView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var balanceLabel: UILabel!
    @IBOutlet private weak var oscillationLabel: UILabel!
    @IBOutlet private weak var actionsHolderView: UIView!
    
    // MARK: - Properties
    
    private var model: CryptoInfoViewModel!
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Setup UI
    
    func setup(with model: CryptoInfoViewModel) {
        self.model = model

        nameLabel.text = model.cryptoInfo.name
        balanceLabel.text = attributedBalance(model.cryptoInfo.priceInEuro.value.bringToPresentableFormat(maximumFractionDigits: 8))
        oscillationLabel.attributedText = model.attributedOscillation
        
        contentHolderStackView.setCustomSpacing(12, after: balanceLabel)
        contentHolderStackView.setCustomSpacing(12, after: oscillationLabel)

        setupActionsHolderView()

        bindToBalanceInEuro()
        bindToOscillationByPercent()
    }

    private func setupActionsHolderView() {
        guard model.canBuyCrypto || model.canSellCrypto,
            let footerView = CryptoDetailsFooterView.loadFromNib() else {
            
            actionsHolderView.isHidden = true
            
            return
        }

        actionsHolderView.isHidden = false
        footerView.setup(with: model.actionsSetupModel)
        footerView.translatesAutoresizingMaskIntoConstraints = false

        self.actionsHolderView.addSubview(footerView)
        footerView.addBorderConstraints(constraintSides: .all)
    }

    private func attributedBalance(_ balance: String) -> String {
        return "\(Constants.euro) \(balance)"
    }

    // MARK: - Binding

    private func bindToBalanceInEuro() {
        model.cryptoInfo.priceInEuro
            .sink { [ weak self ] priceInEuro in
                guard let self else { return }
                
                self.balanceLabel.text = self.attributedBalance(self.model.cryptoInfo.priceInEuro.value.bringToPresentableFormat(maximumFractionDigits: 8))
            }
            .store(in: &cancellables)
    }
    
    private func bindToOscillationByPercent() {
        model.cryptoInfo.oscillationByPercent
            .sink { [ weak self ] oscillationByPercent in
                self?.oscillationLabel.attributedText = self?.model.attributedOscillation
            }
            .store(in: &cancellables)
    }

    // MARK: - Actions
        
    @IBAction private func totalReturnInfoButtonTouchUp(_ sender: UIButton) {
        model.infoButtonPublisher.send(())
    }
}
