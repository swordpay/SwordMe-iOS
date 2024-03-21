//
//  CryptoAccountHeaderViewModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 09.03.23.
//

import Foundation

final class CryptoAccountHeaderViewModel {
    let cryptoAccountModel: CryptoAccountModel
    let searchBarSetupModel: SearchBarHeaderViewModel
    
    init(cryptoAccountModel: CryptoAccountModel,
         searchBarSetupModel: SearchBarHeaderViewModel) {
        self.cryptoAccountModel = cryptoAccountModel
        self.searchBarSetupModel = searchBarSetupModel
    }
    
    var attributedTotalReturn: NSAttributedString {
        let currentTheme = ThemeProvider.currentTheme
        let isTotalReturnNegative = cryptoAccountModel.totalReturn < 0
        let color = isTotalReturnNegative ? currentTheme.colors.mainRed : currentTheme.colors.indicatorGreen
        let amountPrefix = isTotalReturnNegative ? " - " : " "
        let font = ThemeProvider.currentTheme.fonts.regular(ofSize: 13, family: .rubik)
        
        
        let attributedAmount = NSAttributedString(string: "\(amountPrefix)€\(cryptoAccountModel.totalReturn) (\(cryptoAccountModel.totalReturnByPercent)%)",
                                                  attributes: [.foregroundColor: color,
                                                               .font: font])
        let mutablePrefix = NSMutableAttributedString(string: Constants.Localization.CryptoAccount.totalReturn,
                                                      attributes: [.foregroundColor: currentTheme.colors.textColor,
                                                                   .font: font])
        
        mutablePrefix.append(attributedAmount)
                                                  
        return mutablePrefix
    }
}
