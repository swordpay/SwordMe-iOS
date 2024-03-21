//
//  BuyOrSellCryptoViewModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 09.03.23.
//

import Combine
import Foundation

struct BuyOrSellCryptoViewModelInputs {
    let tradeInfoService: CryptoTradeInfoServicing
    let buyCryptoService: BuyCryptoServicing
    let sellCryptoService: SellCryptoServicing
}

final class BuyOrSellCryptoViewModel: BaseViewModel<BuyOrSellCryptoViewModelInputs>, StackViewModeling {
    var setupModel: CurrentValueSubject<BuyOrSellCryptoStackViewModel?, Never>
    let cryptoActionPublisher: PassthroughSubject<Void, Never> = PassthroughSubject()
    let redirectUrlPublisher: PassthroughSubject<String, Never> = PassthroughSubject()
    let sellCryptoCompletionPubliser: PassthroughSubject<Bool, Never> = PassthroughSubject()
    let buyCryptoCompletionPubliser: PassthroughSubject<Void, Never> = PassthroughSubject()
    
    let cryptoModel: CryptoModel
    let action: CryptoActionType
    private var expirationTimer: Timer?
    
    lazy var buyOrSellButtonViewModel: GradientedButtonModel = {
        let title = action == .buy ? Constants.Localization.Common.buy : Constants.Localization.Common.sell
        
        return GradientedButtonModel(title: title,
                                     hasBorders: false,
                                     isActive: true,
                                     action: { [ weak self ] in
            guard let self else { return }
            
            if self.action == .buy {
                self.buyCrypto()
            } else {
                self.sellCrypto()
            }
        })
    }()
    
    init(inputs: BuyOrSellCryptoViewModelInputs, cryptoActionModel: CryptoActionModel) {
        self.cryptoModel = cryptoActionModel.crypto
        self.action = cryptoActionModel.action
        
        self.setupModel = .init(.init(cryptoActionModel: cryptoActionModel))
        
        super.init(inputs: inputs)
        
        bindToAmountValidState()
    }
    
    func fetchTradeInfoData(isPerformedInBackground: Bool = false) {
        let route = CryptoTradeInfoParams(coin: cryptoModel.abbreviation, action: action)
        
        if !isPerformedInBackground {
            isLoading.send(true)
        }
        
        inputs.tradeInfoService.fetch(route: route)
            .receive(on: RunLoop.main)
            .sink { [ weak self] completion in
                guard let self else { return }
                if !isPerformedInBackground {
                    self.isLoading.send(false)
                    if case let .failure(error) = completion {
                        self.error.send(error)
                    }
                }
            } receiveValue: { [ weak self ] response in
                self?.setupModel.value?.tradeInfos.send(response.info)
            }
            .store(in: &cancellables)
    }
    
    func buyCrypto() {
        guard let setupModel = setupModel.value,
              let amount = setupModel.amountPublisher.value?.formattedDecimalNumber(maximumFractionDigits: setupModel.precision) else { return }
        
        let amountType = setupModel.amountTypeSegmentedControlViewModel.selectedIndex.value == 0 ? "crypto" : "fiat"
        let route = BuyCryptoParams(coin: cryptoModel.abbreviation,
                                    amount: amount,
                                    amountType: amountType)
        
        isLoading.send(true)
        
        inputs.buyCryptoService.fetch(route: route)
            .receive(on: RunLoop.main)
            .sink { [ weak self ] completion in
                self?.isLoading.send(false)
                
                
                if case let .failure(error) = completion {
                    self?.error.send(error)
                }
            } receiveValue: { [ weak self ] response in
                NotificationCenter.default.post(name: .accountInfoDidChange, object: nil)
                guard let redirectUrl = response.data.redirectUrl else {
                    // TODO: - Redirect to crypto tab
                    self?.buyCryptoCompletionPubliser.send(())
                    
                    return
                }
                
                self?.redirectUrlPublisher.send(redirectUrl)
            }
            .store(in: &cancellables)
    }
    
    func sellCrypto() {
        guard let setupModel = setupModel.value,
              let amount = setupModel.amountPublisher.value?.formattedDecimalNumber(maximumFractionDigits: setupModel.precision) else { return }
        
        let amountType = setupModel.amountTypeSegmentedControlViewModel.selectedIndex.value == 0 ? "crypto" : "fiat"
        let route = SellCryptoParams(coin: cryptoModel.abbreviation,
                                     amount: amount,
                                     amountType: amountType)
        
        isLoading.send(true)
        
        inputs.sellCryptoService.fetch(route: route)
            .receive(on: RunLoop.main)
            .sink { [ weak self ] completion in
                self?.isLoading.send(false)
                if case let .failure(error) = completion {
                    self?.error.send(error)
                }
            } receiveValue: { [ weak self ] response in
                NotificationCenter.default.post(name: .accountInfoDidChange, object: nil)
                self?.sellCryptoCompletionPubliser.send(response.data.success ?? false)
            }
            .store(in: &cancellables)
    }
    
    func provideMessageForSellingCompeltion(isSuccess: Bool) -> String {
        return isSuccess ? "Your transaction has been completed successfully"
        : "Your transaction has been failed"
    }
    
    // MARK: - Binding
    
    private func bindToAmountValidState() {
        setupModel.value?.isAmountValid
            .sink { [ weak self] isAmountValid in
                self?.buyOrSellButtonViewModel.isActive.send(isAmountValid)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Timer

    func startTimer() {
        expirationTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: { [ weak self ] timer in
            guard let self else { return }
            
            self.fetchTradeInfoData(isPerformedInBackground: true)
        })
    }
    
    func stopTimer() {
        expirationTimer?.invalidate()
        expirationTimer = nil
    }
}
