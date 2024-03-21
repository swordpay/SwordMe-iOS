//
//  CryptoAccountHeaderView.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 09.03.23.
//

import UIKit
import Combine

final class CryptoAccountHeaderView: SetupableView {
    // MARK: - IBOutlets
    
    @IBOutlet private weak var searchBarHolderView: UIView!
    @IBOutlet private weak var contentHolderStackView: UIStackView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var balanceLabel: UILabel!
    @IBOutlet private weak var totalReturnLabel: UILabel!
    
    // MARK: - Properties
    
    private var model: CryptoAccountHeaderViewModel!
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Setup UI
    
    func setup(with model: CryptoAccountHeaderViewModel) {
        self.model = model
        
        titleLabel.text = Constants.Localization.CryptoAccount.yourCryptoBalance
        balanceLabel.attributedText = model.cryptoAccountModel.balanceInEuro.value.formattedDecimalNumber(maximumFractionDigits: 2).attributedBalance()

        totalReturnLabel.attributedText = model.attributedTotalReturn
        
        contentHolderStackView.setCustomSpacing(12, after: balanceLabel)
        
        setupSearchBar()
        bindToBalanceInEuro()
    }
    
    private func setupSearchBar() {
        guard let headerView = SearchBarHeaderView.loadFromNib() else { return }
        
        headerView.setup(with: model.searchBarSetupModel)
        headerView.setCornerRadius()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        self.searchBarHolderView.addSubview(headerView)
        headerView.addBorderConstraints(constraintSides: .all)
    }
    
    private func bindToBalanceInEuro() {
        model.cryptoAccountModel.balanceInEuro
            .sink { [ weak self ] balanceInEuro in
                self?.balanceLabel.attributedText = balanceInEuro.formattedDecimalNumber(maximumFractionDigits: 2).attributedBalance()
            }
            .store(in: &cancellables)
    }
}
