//
//  ChannelPaymnetAmountViewModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 22.05.23.
//

import Combine
import Foundation

final class ChannelPaymnetAmountViewModel {
    var selectedCrypto: CurrentValueSubject<CryptoInfo?, Never> = CurrentValueSubject(nil)
    var amount: CurrentValueSubject<String?, Never> = CurrentValueSubject(nil)
    let canChangePaymentMethods: CurrentValueSubject<Bool, Never>
    let cryptoPickerChangePusblisher: PassthroughSubject<Void, Never> = .init()
    let editAmountButtonPublisher: PassthroughSubject<Void, Never> = .init()

    let title: String
    let cryptoInfoViewModel: ChannelPaymnetAmountCryptoInfoViewModel
    let isPaying: Bool
    let amountType: CurrentValueSubject<AmountType, Never> = .init(.fiat)
    let amountTypePickerPublisher: PassthroughSubject<Void, Never> = .init()
    var canEditAmount: CurrentValueSubject<Bool, Never>
    
    let manipulator = AmountManipulator()
    let textChecker = TextChangeChecker(precision: Constants.fiatDefaultPrecision, mainPartMaxLenght: Constants.maximumDigitsOfDouble)

    var precistionCount: Int {
        return amountType.value == .fiat ? Constants.fiatDefaultPrecision : Constants.cryptoDefaultPrecision
    }

    var attributedPlaceholder: NSAttributedString {
        let theme = ThemeProvider.currentTheme
        let placeholderColor = theme.colors.lightGray2
        

        return NSAttributedString(string: "0",
                                  attributes: [.foregroundColor: placeholderColor,
                                               .font: theme.fonts.regular(ofSize: 48, family: .poppins)])
    }
    
    
    init(selectedCoin: ChannelPaymnetAmountViewModel.CryptoInfo? = nil, isPaying: Bool, canChangePaymentMethods: Bool, canEditAmount: Bool = false, title: String) {
        self.selectedCrypto = .init(selectedCoin)
        self.canEditAmount = .init(canEditAmount)
        self.cryptoInfoViewModel = .init(cryptoModel: selectedCoin)
        self.canChangePaymentMethods = .init(canChangePaymentMethods)
        self.isPaying = isPaying
        self.title = title
    }
}

extension ChannelPaymnetAmountViewModel {
    struct CryptoInfo {
        let selectedCoin: CryptoPickerItemCellModel.CoinInfo
        let price: Double
    }
}
