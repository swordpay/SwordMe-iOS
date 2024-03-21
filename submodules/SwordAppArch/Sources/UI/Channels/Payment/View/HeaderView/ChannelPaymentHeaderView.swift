//
//  ChannelPaymentHeaderView.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 27.12.22.
//

import UIKit
import Combine

final class ChannelPaymentHeaderView: SetupableView {
    
    // MARK: - IBOutlets

    @IBOutlet private weak var mainHolderStackView: UIStackView!
    @IBOutlet private weak var segmentedControlHolderView: UIView!
    @IBOutlet private weak var separatorView: UIView!
    
    @IBOutlet private weak var requestInfoStackView: UIStackView!
    @IBOutlet private weak var requestAmountLabel: UILabel!
    @IBOutlet private weak var requestSenderLabel: UILabel!

    @IBOutlet private weak var amountHolderView: UIView!
    @IBOutlet private weak var participantsHolderView: UIView!
    
    // MARK: - Properties
    
    private var model: ChannelPaymentHeaderViewModel!
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Setup UI
    
    func setup(with model: ChannelPaymentHeaderViewModel) {
        self.model = model
        
        mainHolderStackView.setCustomSpacing(30, after: segmentedControlHolderView)
        mainHolderStackView.setCustomSpacing(20, after: participantsHolderView)
        mainHolderStackView.setCustomSpacing(36, after: amountHolderView)

        setupMembersView()
        setupRequestInfo()
        setupSegmentedControl()
        setupAmountHolderView()

        bindToSelectedCoin()
    }
    
    private func setupSegmentedControl() {
        guard let setupModel = model.paymentMethodTypeSegmentedControlViewModel,
              let segmentedControl = SegmentedControl.loadFromNib() else {
            segmentedControlHolderView.isHidden = true
            
            return
        }

        segmentedControlHolderView.isHidden = false
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControlHolderView.addSubview(segmentedControl)
        
        segmentedControl.addBorderConstraints(constraintSides: .all)
        segmentedControl.setup(with: setupModel)
    }
    
    private func setupMembersView() {
        guard let membersView = ChannelPaymentParticipantsView.loadFromNib() else { return }
        
        membersView.translatesAutoresizingMaskIntoConstraints = false
        membersView.setup(with: model.membersInfoSetupModel)
        
        participantsHolderView.addSubview(membersView)
        membersView.addBorderConstraints(constraintSides: .all)
    }

    private func setupRequestInfo() {
        guard let requestInfo = model.requestInfo else {
            requestInfoStackView.isHidden = true
            
            return
        }
        
        var requestAmount: String? {
            var amount: String {
                return Double(requestInfo.amount)?.bringToPresentableFormat(maximumFractionDigits: 8) ?? requestInfo.amount
            }

            let currency = requestInfo.currency == "EUR" ? Constants.euro : requestInfo.currency
            return "\(currency) \(amount)"
        }

        requestInfoStackView.isHidden = false
        requestAmountLabel.text = requestAmount
        requestSenderLabel.text = "Requested Amount"
    }

    private func setupAmountHolderView() {
        guard let amountView = ChannelPaymnetAmountView.loadFromNib() else { return }
        
        amountView.translatesAutoresizingMaskIntoConstraints = false
        amountView.setup(with: model.amountViewSetupModel)
        
        amountHolderView.addSubview(amountView)
        amountView.addBorderConstraints(constraintSides: .all)
    }

    // MARK: - Binding
            
    private func bindToSelectedCoin() {
        model.selectedCoinPublisher
            .dropFirst()
            .sink { [ weak self ] coin in
                guard let coin,
                      let price = self?.model.priceForSelectedCoin() else { return }
                
                self?.model.amountViewSetupModel.selectedCrypto.send(.init(selectedCoin: coin, price: price))
                self?.model.paymentMethodTypeInfo.send(.init(name: coin.name,
                                                         abbreviation: coin.abbriviation,
                                                         icon: coin.iconPath))
            }
            .store(in: &cancellables)
    }
    
    @objc
    private func paymentMethodTypeTapHandler() {
        guard model.canChangePaymentMethods else { return }

        model.paymentMethodTypeHandler.send(())
    }
}
