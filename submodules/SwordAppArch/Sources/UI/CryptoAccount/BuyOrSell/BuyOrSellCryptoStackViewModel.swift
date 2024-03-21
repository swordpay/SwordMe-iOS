//
//  BuyOrSellCryptoStackViewModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 09.03.23.
//

import Combine
import Foundation
import Display
import AsyncDisplayKit

final class BuyOrSellCryptoStackViewModel {
    private var cancellables: Set<AnyCancellable> = []
    let tradeInfos: CurrentValueSubject<CryptoTradeInfoResponse.Info?, Never> = CurrentValueSubject(nil)
    
    var precision: Int {
        return tradeInfos.value?.coin.precision ?? Constants.cryptoDefaultPrecision
    }
    
    let manipulator = AmountManipulator()
    let textChecker = TextChangeChecker(precision: Constants.fiatDefaultPrecision, mainPartMaxLenght: Constants.maximumDigitsOfDouble)
    
    let cryptoModel: CryptoModel
    let action: CryptoActionType
    
    let amountPublisher: CurrentValueSubject<String?, Never>
    let isAmountValid: CurrentValueSubject<Bool, Never> = CurrentValueSubject(false)
    let convertedAmountPublisher: PassthroughSubject<String?, Never> = PassthroughSubject()
    let amountValidationErrorMessagePublisher: CurrentValueSubject<String?, Never> = CurrentValueSubject(nil)
    
    let contextMenuPublisher: PassthroughSubject<(ViewController, ASDisplayNode, CGRect), Never> = .init()
    private var isCryptoSelected: Bool {
        return amountTypeSegmentedControlViewModel.selectedIndex.value == 0
    }
    
    var attributedPlaceholder: NSAttributedString {
        let theme = ThemeProvider.currentTheme
        let placeholderColor = theme.colors.lightGray2
        
        
        return NSAttributedString(string: Constants.Localization.FiatAccount.externalTransferAmount,
                                  attributes: [.foregroundColor: placeholderColor,
                                               .font: theme.fonts.regular(ofSize: 22, family: .poppins)])
    }
    
    var amountTypeSegmentedControlViewModel: SegmentedControlSetupModel
    
    var userBalance: Amounts? {
        guard let accountInfo = cryptoModel.accountInfo else { return nil }
        
        return .init(fiatPrice: (accountInfo.balance.value * cryptoModel.priceInEuro.value).bringToPresentableFormat(maximumFractionDigits: Constants.fiatDefaultPrecision),
                     cryptoPrice: accountInfo.balance.value.bringToPresentableFormat(maximumFractionDigits: precision))
    }
    
    var tradeInfoMinAmount: Amounts? {
        guard let info = tradeInfos.value else { return nil }
        
        let currencyMinPrice: Double = info.coin.min * cryptoModel.priceInEuro.value
        
        return .init(fiatPrice: max(1, currencyMinPrice).bringToPresentableFormat(maximumFractionDigits: Constants.fiatDefaultPrecision),
                     cryptoPrice: info.coin.min.bringToPresentableFormat(maximumFractionDigits: precision))
    }
    
    var tradeInfoMaxAmount: Amounts? {
        guard let info = tradeInfos.value else { return nil }
        
        let currencyMaxPrice: Double = info.coin.max * cryptoModel.priceInEuro.value
        
        return .init(fiatPrice: currencyMaxPrice.bringToPresentableFormat(maximumFractionDigits: Constants.fiatDefaultPrecision),
                     cryptoPrice: info.coin.max.bringToPresentableFormat(maximumFractionDigits: precision))
    }
    
    func tradeInfo(from amountInfo: Amounts?) -> String? {
        guard let amountInfo else { return nil }
        
        return "\(amountInfo.cryptoPrice) \(cryptoModel.abbreviation) ≈ \(amountInfo.fiatPrice) EUR"
    }
    
    let amount: Double?
    var numberOfDropingElements: Int {
        return amount == nil ? 1 : 0
    }
    
    init(cryptoActionModel: CryptoActionModel) {
        self.cryptoModel = cryptoActionModel.crypto
        self.action = cryptoActionModel.action
        self.amount = cryptoActionModel.amount
        let initialAmount: String? = {
            guard let amount = cryptoActionModel.amount else { return nil }
            
            return "\(amount)"
        }()
        
        self.amountPublisher = .init(initialAmount)
        
        let isCryptoSelected: Bool = {
            guard let amountType = cryptoActionModel.amountType else { return true }
            
            return amountType == .crypto
            
        }()
        
        amountTypeSegmentedControlViewModel = SegmentedControlSetupModel(models: [
            .init(title: Constants.Localization.Common.crypto,
                  isSelected: CurrentValueSubject(isCryptoSelected)),
            .init(title: Constants.Localization.Common.cash,
                  isSelected: CurrentValueSubject(!isCryptoSelected))
        ])
        
        bindToAmount()
        bindToSelectedAmountType()
        bindToCoinEuroPriceUpdate()
    }
    
    func provideAmount(for labelIndex: Int?) -> Amounts? {
        guard let labelIndex else { return nil }
        
        if labelIndex == 1 {
            return userBalance
        } else if labelIndex == 2 {
            return tradeInfoMinAmount
        } else {
            return tradeInfoMaxAmount
        }
    }
    
    func provideAmountCorrectValue(for labelIndex: Int?) -> Amounts? {
        guard let labelIndex else { return nil }
        
        if labelIndex == 1 {
            guard let accountInfo = cryptoModel.accountInfo else { return nil }
            
            return .init(fiatPrice: (accountInfo.balance.value * cryptoModel.priceInEuro.value).formattedDecimalNumber(maximumFractionDigits: Constants.fiatDefaultPrecision),
                         cryptoPrice: accountInfo.balance.value.formattedDecimalNumber(maximumFractionDigits: precision))
        } else if labelIndex == 2 {
            guard let info = tradeInfos.value else { return nil }
            
            let currencyMinPrice: Double = info.coin.min * cryptoModel.priceInEuro.value
            
            return .init(fiatPrice: max(1, currencyMinPrice).formattedDecimalNumber(maximumFractionDigits: Constants.fiatDefaultPrecision),
                         cryptoPrice: info.coin.min.formattedDecimalNumber(maximumFractionDigits: precision))
        } else {
            guard let info = tradeInfos.value else { return nil }
            
            let currencyMaxPrice: Double = info.coin.max * cryptoModel.priceInEuro.value
            
            return .init(fiatPrice: currencyMaxPrice.formattedDecimalNumber(maximumFractionDigits: Constants.fiatDefaultPrecision),
                         cryptoPrice: info.coin.max.formattedDecimalNumber(maximumFractionDigits: precision))
        }
    }
    
    
    func handleAmount(_ amount: String?) {
        guard let amount, !amount.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            amountValidationErrorMessagePublisher.send(nil)
            isAmountValid.send(false)
            convertedAmountPublisher.send(nil)
            
            return
        }
        
        guard let doubledAmount = amount.formattedDecimalNumber(maximumFractionDigits: precision) else {
            amountValidationErrorMessagePublisher.send("\(Constants.Localization.CryptoAccount.invalidAmount)")
            isAmountValid.send(false)
            convertedAmountPublisher.send(nil)
            
            return
        }
        
        let isAmountValid = validateAmount(doubledAmount)
        self.isAmountValid.send(isAmountValid)
        if isAmountValid {
            prepareConvertedAmount(priceInEuro: cryptoModel.priceInEuro.value, amount: doubledAmount)
        } else {
            convertedAmountPublisher.send(nil)
        }
    }
    
    // MARK: - Binding
    
    private func bindToAmount() {
        amountPublisher
            .dropFirst()
            .sink { [ weak self ] amount in
                self?.handleAmount(amount)
            }
            .store(in: &cancellables)
    }
    
    private func bindToSelectedAmountType() {
        amountTypeSegmentedControlViewModel.selectedIndex
            .dropFirst()
            .sink { [ weak self ] selectedIndex in
                if (self?.amountPublisher.value ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    self?.isAmountValid.send(false)
                    self?.amountValidationErrorMessagePublisher.send(nil)
                } else {
                    self?.amountPublisher.send(self?.amountPublisher.value)
                }
            }
            .store(in: &cancellables)
    }
    
    private func bindToCoinEuroPriceUpdate() {
        cryptoModel.priceInEuro
            .sink { [ weak self ] price in
                guard let self,
                      let amount = self.amountPublisher.value,
                      let doubledAmount = amount.formattedDecimalNumber(maximumFractionDigits: precision) else {
                    return
                }
                
                self.prepareConvertedAmount(priceInEuro: price, amount: doubledAmount)
                self.handleAmount(amount)
            }
            .store(in: &cancellables)
    }
    
    private func validateAmount(_ amount: Double) -> Bool {
        if action == .buy {
            guard let tradeInfos = tradeInfos.value else { return false }

            lazy var coinPriceInEuro = cryptoModel.priceInEuro.value
            lazy var currencyRange = CryptoTradeInfoResponse.ValueRange(min: max(tradeInfos.coin.min * coinPriceInEuro, 1),
                                                                        max: tradeInfos.coin.max * coinPriceInEuro,
                                                                        precision: Constants.fiatDefaultPrecision)
            let range = isCryptoSelected ? tradeInfos.coin : currencyRange
            let precision = isCryptoSelected ? precision : Constants.fiatDefaultPrecision
            
            guard amount >= prepareCorrectPrecision(for: range.min, precision: precision) else {
                self.amountValidationErrorMessagePublisher.send(("Minimum allowed value is \(range.min.formattedDecimalNumber(maximumFractionDigits: precision))"))
                
                return false
            }
            
            guard amount <= prepareCorrectPrecision(for: range.max, precision: precision) else {
                self.amountValidationErrorMessagePublisher.send(("Maximum allowed value is \(range.max.formattedDecimalNumber(maximumFractionDigits: precision))"))
                
                return false
            }
            
            self.amountValidationErrorMessagePublisher.send(nil)
            
            return true
        } else {
            guard let tradeInfos = tradeInfos.value,
                  let accountInfo = cryptoModel.accountInfo else { return false }
            
                lazy var coinPriceInEuro = cryptoModel.priceInEuro.value
            lazy var currencyRange = CryptoTradeInfoResponse.ValueRange(min: max(tradeInfos.coin.min * coinPriceInEuro, 1),
                                                                        max: tradeInfos.coin.max * coinPriceInEuro,
                                                                        precision: tradeInfos.coin.precision)
            
            lazy var coinPrice = cryptoModel.priceInEuro.value
            lazy var coinRange = CryptoTradeInfoResponse.ValueRange(min: tradeInfos.coin.min,
                                                                    max: tradeInfos.coin.max,
                                                                    precision: tradeInfos.coin.precision)
            
            let range = isCryptoSelected ? coinRange : currencyRange
            let precision = isCryptoSelected ? precision : Constants.fiatDefaultPrecision
            
            
            guard amount >= prepareCorrectPrecision(for: range.min, precision: precision) else {
                self.amountValidationErrorMessagePublisher.send(("Minimum allowed value is \(range.min.formattedDecimalNumber(maximumFractionDigits: precision))"))
                
                return false
            }
            
            guard amount <= prepareCorrectPrecision(for: range.max, precision: precision) else {
                self.amountValidationErrorMessagePublisher.send(("Maximum allowed value is \(range.max.formattedDecimalNumber(maximumFractionDigits: precision))"))
                
                return false
            }

            guard amount <= accountInfo.balance.value else {
                self.amountValidationErrorMessagePublisher.send("Balance exceeded")
                
                return false
            }
            
            self.amountValidationErrorMessagePublisher.send(nil)
            
            return true
        }
    }
    
    // MARK: - Amount converting
    
    private func prepareConvertedAmount(priceInEuro: Double , amount: Double) {
        let isCryptoSelected = amountTypeSegmentedControlViewModel.selectedIndex.value == 0
        let convertedAmount = isCryptoSelected ? amount * priceInEuro : amount / priceInEuro
        let prefix = !isCryptoSelected ? "\(cryptoModel.abbreviation) " : "€ "
        let convertedAmountText = "\(prefix)\(convertedAmount.bringToPresentableFormat(maximumFractionDigits: isCryptoSelected ? Constants.fiatDefaultPrecision : precision))"
        
        convertedAmountPublisher.send(convertedAmountText)
    }
    
    private func prepareCorrectPrecision(for amount: Double, precision: Int) -> Double {
        return amount.formattedDecimalNumber(maximumFractionDigits: precision).formattedDecimalNumber(maximumFractionDigits: precision) ?? amount
    }
}

extension BuyOrSellCryptoStackViewModel {
    struct Amounts {
        let fiatPrice: String
        let cryptoPrice: String
    }
}
