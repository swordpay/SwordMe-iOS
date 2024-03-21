//
//  CryptoDetailsViewController.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 09.03.23.
//

import UIKit

final class CryptoDetailsViewController: GenericStackViewController<CryptoDetailsViewModel, CryptoDetailsStackView> {
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        title = viewModel.cryptoInfo.abbreviation
        hidesBottomBarWhenPushed = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if viewModel.cryptoAccountInfoDidChange {
            viewModel.fetchCryptoInfo()
        }
    }

    // MARK: - Binding
    
    override func bindViewModel() {
        super.bindViewModel()
        
        bindToInfoButtonPublisher()
        bindToCryptoActionPublisher()
    }
    
    private func bindToCryptoActionPublisher() {
        viewModel.setupModel.value?.cryptoInfoSetupModel.actionsSetupModel.cryptoActionPublisher
            .sink { [ weak self ] action in
                guard let self else { return }
                
                self.goToBuyOrSellCryptoScreen(cryptoActionModel: .init(crypto: self.viewModel.cryptoInfo,
                                                                        action: action))
            }
            .store(in: &cancellables)
    }
    
    private func bindToInfoButtonPublisher() {
        viewModel.infoButtonPublisher?.sink { [ weak self ] in
            self?.showTotalReturnInfoAlert()
        }
        .store(in: &cancellables)
    }
    
    // MARK: - Navigation

    private func showTotalReturnInfoAlert() {
        let alertModel = AlertModel(title: Constants.Localization.Common.information,
                                    message: Constants.Localization.CryptoAccount.totalReturnInfo,
                                    preferredStyle: .alert,
                                    actions: [.ok],
                                    animated: true)
        
        let destination = AlertDestination.alert(model: alertModel, presentationCompletion: nil, actionCompletion: nil)
        
        navigator.goTo(destination)
    }

    private func goToBuyOrSellCryptoScreen(cryptoActionModel: CryptoActionModel) {
        navigator.goTo(CryptoAccountDestination.buyOrSell(cryptoActionModel: cryptoActionModel))
    }
}

extension CryptoDetailsViewController: Deeplinking {
    func deeplink(to dest: DeeplinkDestinationing, completion: @escaping (UIViewController?) -> Void) {
//        guard let accountDestination = dest as? CryptoAccountDeeplinkDestination else {
//            completion(nil)
//
//            return
//        }
//
//        switch accountDestination {
//        case .buyCrypto(let queryItems):
//            var amount: Double?
//            var amountType: AmountType?
//
//            if let amountValue = queryItems.first(where: { $0.name == "amount" })?.value,
//               let doubledAmount = Double(amountValue) {
//                amount = doubledAmount
//            }
//            
//            if let typeRawValue = queryItems.first(where: { $0.name == "amountType" })?.value,
//               let type = AmountType(rawValue: typeRawValue) {
//                amountType = type
//            }
//            
//            let cryptoActionModel = CryptoActionModel(crypto: viewModel.cryptoInfo,
//                                                      action: .buy,
//                                                      amount: amount,
//                                                      amountType: amountType)
//            
//            goToBuyOrSellCryptoScreen(cryptoActionModel: cryptoActionModel)
//        default:
//            return
//        }
    }
}
