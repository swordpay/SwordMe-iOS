//
//  CryptoUserInfoViewModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 09.03.23.
//

import Combine
import Foundation

final class CryptoUserInfoViewModel {
    let cryptoInfo: CryptoModel

    var isAccountInfoVisible: Bool {
        return cryptoInfo.accountInfo != nil
    }

    var attributedTotalReturn: NSAttributedString {
        guard let cryptoAccountModel = cryptoInfo.accountInfo else { return NSAttributedString(string: "") }

        let currentTheme = ThemeProvider.currentTheme
        let isTotalReturnNegative = cryptoAccountModel.totalReturn < 0
        let color = isTotalReturnNegative ? currentTheme.colors.mainRed : currentTheme.colors.indicatorGreen
        let amountPrefix = isTotalReturnNegative ? " - " : " + "
        let font = ThemeProvider.currentTheme.fonts.regular(ofSize: 13, family: .rubik)
        
        
        let attributedAmount = NSAttributedString(string: "\(amountPrefix)€\(cryptoAccountModel.totalReturn) (\(cryptoAccountModel.totalReturnByPercent)%)",
                                                  attributes: [.foregroundColor: color,
                                                               .font: font])
                                                  
        return attributedAmount
    }

    init(cryptoInfo: CryptoModel) {
        self.cryptoInfo = cryptoInfo
    }
}
