//
//  CryptoUserInfoView.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 09.03.23.
//

import UIKit
import Combine

final class CryptoUserInfoView: SetupableView {

    // MARK: - IBOutlets

    @IBOutlet private weak var contentHolderStackView: UIStackView!
    @IBOutlet private weak var accountInfoHolderStackView: UIStackView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var yourCryptoTitleLabel: UILabel!
    @IBOutlet private weak var yourCryptoAmountLabel: UILabel!
    @IBOutlet private weak var cryptoEuroValueTitleLabel: UILabel!
    @IBOutlet private weak var cryptoEuroValueLabel: UILabel!
    @IBOutlet private weak var totalReturnTitleLabel: UILabel!
    @IBOutlet private weak var totalReturnLabel: UILabel!
    
    @IBOutlet private weak var actionsHolderStackView: UIStackView!
    @IBOutlet private weak var externalTransferButton: UIButton!
    @IBOutlet private weak var detailsButton: UIButton!

    // MARK: - Properties

    private var model: CryptoUserInfoViewModel!
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Setup UI

    func setup(with model: CryptoUserInfoViewModel) {
        self.model = model

        accountInfoHolderStackView.isHidden = !model.isAccountInfoVisible
        contentHolderStackView.setCustomSpacing(39, after: actionsHolderStackView)

        setupTitles()
        setupCryptoInfo()
        bindToAccountCryptoPriceInEuro()
    }

    private func setupTitles() {
        titleLabel.text = "\(Constants.Localization.CryptoAccount.your) \(model.cryptoInfo.name)"
        yourCryptoTitleLabel.text = "\(Constants.Localization.CryptoAccount.your) \(model.cryptoInfo.name)"
        cryptoEuroValueTitleLabel.text = Constants.Localization.CryptoAccount.euroValue
        totalReturnTitleLabel.text = Constants.Localization.CryptoAccount.totalReturn
    }
    
    private func setupCryptoInfo() {
        let balance = (model.cryptoInfo.accountInfo?.balance.value ?? 0.0).bringToPresentableFormat(maximumFractionDigits: Constants.cryptoDefaultPrecision)
        let balanceInEuro = (model.cryptoInfo.accountInfo?.balanceInEuro.value ?? 0.0).bringToPresentableFormat(maximumFractionDigits: Constants.fiatDefaultPrecision)
        yourCryptoAmountLabel.text = "\(balance) \(model.cryptoInfo.abbreviation)"
        cryptoEuroValueLabel.text = "€\(balanceInEuro)"
        totalReturnLabel.attributedText = model.attributedTotalReturn
    }
    
    private func bindToAccountCryptoPriceInEuro() {
        model.cryptoInfo.accountInfo?.balanceInEuro
            .sink(receiveValue: { [ weak self ] price in
                let balanceInEuro = price.bringToPresentableFormat(maximumFractionDigits: Constants.fiatDefaultPrecision)
                
                self?.cryptoEuroValueLabel.text = "€\(balanceInEuro)"
            })
            .store(in: &cancellables)
    }
}
