//
//  CryptoAccountEmptyStateView.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 10.02.23.
//

import UIKit
import Combine

final class CryptoAccountEmptyStateView: SetupableView {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var borderedHolderView: UIView!
    @IBOutlet private weak var amountLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var cryptosHolderStackView: UIStackView!
    @IBOutlet private weak var gradientedCoverView: GradientedBorderedView!
    @IBOutlet private weak var goToMarketButton: UIButton!
    
    // MARK: - Properties
    
    private var model: CryptoAccountEmptyStateViewModel!
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Setup UI
    
    func setup(with model: CryptoAccountEmptyStateViewModel) {
        self.model = model
        
        amountLabel.text = "€0"
        descriptionLabel.text = Constants.Localization.CryptoAccount.emptyStateDescription
        
        setupBorderedHolderView()
        setupGradientedCoverView()

        goToMarketButton.setTitle(Constants.Localization.CryptoAccount.goToMarket, for: .normal)
        setupGradientTitledButton(goToMarketButton)
        
        bindToTopCryptos()
    }
    
    private func setupBorderedHolderView() {
        borderedHolderView.setCornerRadius(10)
        borderedHolderView.layer.borderColor = theme.colors.backgroundGray.cgColor
        borderedHolderView.layer.borderWidth = 1
    }
    
    private func setupGradientedCoverView() {
        gradientedCoverView.colors = [ theme.colors.mainWhite.withAlphaComponent(0).cgColor,
                                       theme.colors.mainWhite.cgColor ]
        
        gradientedCoverView.axis = .vertical
        gradientedCoverView.hasBorders = false
    }
    
    private func setupGradientTitledButton(_ button: UIButton) {
        lazy var colors = [theme.colors.gradientLightBlue, theme.colors.gradientDarkBlue]
        let color = GradientedColorProvider.gradientColor(from: colors,
                                                          in: button.titleLabel?.bounds ?? bounds)
        
        button.setTitleColor(color, for: .normal)
    }

    private func setupCryptosInfosView() {
        cryptosHolderStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        model.cryptoInfoItemModels.compactMap { model in
            guard let view = CryptoInfoItemView.loadFromNib() else { return nil }
            
            view.setup(with: model)
            
            return view
        }
        .forEach {
            cryptosHolderStackView.addArrangedSubview($0)
        }
    }

    // MARK: - Binding
    
    private func bindToTopCryptos() {
        model.topThreeCryptos
            .sink { [ weak self ] _ in
                self?.setupCryptosInfosView()
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Actions
    
    @IBAction private func goToMarketButtonTouchUp(_ sender: UIButton) {
        model.goToMarketButtonPublisher.send(())
    }
}
