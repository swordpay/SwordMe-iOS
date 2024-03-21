//
//  CryptoInfoViewModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 09.03.23.
//

import Combine
import Foundation

final class CryptoInfoViewModel {
    let cryptoInfo: CryptoModel

    let infoButtonPublisher: PassthroughSubject<Void, Never> = PassthroughSubject()
    lazy var actionsSetupModel: CryptoDetailsFooterViewModel = .init(canBuy: canBuyCrypto,
                                                                     canSell: canSellCrypto)

    var canBuyCrypto: Bool {
        return true
    }
    
    var canSellCrypto: Bool {
        return cryptoInfo.accountInfo != nil
    }

    init(cryptoInfo: CryptoModel) {
        self.cryptoInfo = cryptoInfo
    }

    var attributedOscillation: NSAttributedString {
        let doubledOscillation = Double(cryptoInfo.oscillationByPercent.value) ?? 0
        let currentTheme = ThemeProvider.currentTheme
        let isOscillationNegative = cryptoInfo.oscillationByPercent.value.contains("-")
        let textColor = isOscillationNegative ? currentTheme.colors.mainRed2 : currentTheme.colors.darkGreen
        let font = currentTheme.fonts.semibold(ofSize: 12, family: .poppins)

        let attributedOscillation = NSMutableAttributedString(string: "\(doubledOscillation.bringToPresentableFormat())% ",
                                                              attributes: [.foregroundColor: textColor,
                                                                           .font: font])
        let attributedPeriod = NSAttributedString(string: "(\(Constants.Localization.CryptoAccount.past24Hours))",
                                                  attributes: [.foregroundColor: currentTheme.colors.tintGray,
                                                               .font: currentTheme.fonts.medium(ofSize: 12, family: .poppins)])

        attributedOscillation.append(attributedPeriod)

        return attributedOscillation
    }
}
