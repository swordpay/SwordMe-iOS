//
//  BuyOrSellCryptoStackView.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 09.03.23.
//
import UIKit
import Combine
import Display
import AsyncDisplayKit

final class BuyOrSellCryptoStackView: SetupableStackView {
    // MARK: - IBOutlets
    
    @IBOutlet private weak var amountTextField: UITextField!
    @IBOutlet private weak var amountTextFieldSeparator: UIView!
    @IBOutlet private weak var amountConvertedValueLabel: UILabel!
    @IBOutlet private weak var amountRangeHolderStackView: UIStackView!
    @IBOutlet private weak var yourBalanceTitleLabel: UILabel!
    @IBOutlet private weak var yourBalanceLabel: UILabel!
    @IBOutlet private weak var minAmountTitleLabel: UILabel!
    @IBOutlet private weak var minAmountLabel: UILabel!
    @IBOutlet private weak var maxAmountTitleLabel: UILabel!
    @IBOutlet private weak var maxAmountLabel: UILabel!
    @IBOutlet private weak var segmentedControlHolderView: UIView!
    @IBOutlet private weak var amountValidationErrorLabel: UILabel!
    @IBOutlet private weak var coinInfoTitleLabel: UILabel!
    @IBOutlet private weak var euroPrefixLabel: UILabel!
    
    // MARK: - Properties
    
    private var selectedLabelIndex: Int?
    private var model: BuyOrSellCryptoStackViewModel!
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Setup UI
    
    func setup(with model: BuyOrSellCryptoStackViewModel) {
        self.model = model
        
        amountTextField.delegate = self
        amountTextField.setupKeyboardToolbar()
        amountTextField.attributedPlaceholder = model.attributedPlaceholder

        if let amount = model.amount {
            amountTextField.text = "\(amount)"
        }

        setupSegmentedControl()

        setupLabelTapGesture(minAmountLabel)
        setupLabelTapGesture(maxAmountLabel)
        setupLabelTapGesture(yourBalanceLabel)

        bindToTradeInfo()
        bindToConvertedAmount()
        bindToSelectedAmountType()
        bindToCryptoPriceInEuroChange()
        bindToAmountValidationErrorMessagePublisher()
    }
    
    private func setupSegmentedControl() {
        guard let segmentedControl = SegmentedControl.loadFromNib() else { return }

        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControlHolderView.addSubview(segmentedControl)
        
        segmentedControl.addBorderConstraints(constraintSides: .all)
        segmentedControl.setup(with: model.amountTypeSegmentedControlViewModel)
    }
    
    private func setupCryptoToEuroInfo(price: Double? = nil) {
        guard model.tradeInfos.value != nil else { return }

        setupBalanceInfo()
        coinInfoTitleLabel.text = Constants.Localization.CryptoAccount.cryptoRanges
        minAmountTitleLabel.text = Constants.Localization.CryptoAccount.minAmount
        minAmountLabel.text = model.tradeInfo(from: model.tradeInfoMinAmount)
        maxAmountTitleLabel.text = Constants.Localization.CryptoAccount.maxAmount
        maxAmountLabel.text = model.tradeInfo(from: model.tradeInfoMaxAmount)
        amountRangeHolderStackView.isHidden = false
    }

    // MARK: - Binding
    
    private func bindToTradeInfo() {
        model.tradeInfos
            .sink { [ weak self ] info in
                guard let self,
                      info != nil else { return }
                self.setupCryptoToEuroInfo()
                if let amount = self.model.amount {
                    self.model.handleAmount("\(amount)")
                }
            }
            .store(in: &cancellables)
    }
    
    private func setupBalanceInfo() {
        guard let balanceInfo = model.userBalance else {
            yourBalanceLabel.isHidden = true
            yourBalanceTitleLabel.isHidden = true
            
            return
        }
        
        yourBalanceLabel.isHidden = false
        yourBalanceTitleLabel.isHidden = false

        yourBalanceTitleLabel.text = "\(Constants.Localization.Common.your) \(model.cryptoModel.abbreviation)"
        yourBalanceLabel.text = model.tradeInfo(from: balanceInfo)
    }
    
    private func setupUI(isValidState: Bool) {
        if isValidState {
            amountTextField.textColor = theme.colors.textColor
            amountTextFieldSeparator.backgroundColor = theme.colors.lightGray4
            amountValidationErrorLabel.isHidden = true
        } else {
            amountTextField.textColor = theme.colors.mainRed
            amountTextFieldSeparator.backgroundColor = theme.colors.mainRed
            amountValidationErrorLabel.isHidden = false
        }
    }

    // MARK: - Binding
    
    private func bindToCryptoPriceInEuroChange() {
        model.cryptoModel.priceInEuro
            .sink { [ weak self ] priceInEuro in
                self?.setupBalanceInfo()
                self?.setupCryptoToEuroInfo(price: priceInEuro)
            }
            .store(in: &cancellables)
    }

    private func bindToConvertedAmount() {
        model.convertedAmountPublisher
            .sink { [ weak self ] amount in
                guard let amount else {
                    self?.amountConvertedValueLabel.isHidden = true
                    
                    return
                }
                
                self?.amountConvertedValueLabel.isHidden = false
                self?.amountConvertedValueLabel.text = amount
            }
            .store(in: &cancellables)
    }
    
    private func bindToAmountValidationErrorMessagePublisher() {
        model.amountValidationErrorMessagePublisher
            .dropFirst()
            .sink { [ weak self ] message in
                guard let self, let message else {
                    self?.setupUI(isValidState: true)
                    self?.amountValidationErrorLabel.isHidden = true
                    
                    return
                }
                
                self.amountValidationErrorLabel.text = message
                self.setupUI(isValidState: false )
            }
            .store(in: &cancellables)
    }
    
    private func bindToSelectedAmountType() {
        model.amountTypeSegmentedControlViewModel.selectedIndex
            .sink { [ weak self ] selectedIndex in
                guard let self else { return }
                
                let isCashSelected = selectedIndex == 1
                let precision = isCashSelected ? 2 : model.precision
                
                self.euroPrefixLabel.isHidden = !isCashSelected
                
                self.model.manipulator.maximumFractionDigits = precision
                self.model.textChecker.precision = precision
                
                amountTextField.text = model.manipulator.manipulate(amountTextField.text ?? "")
            }
            .store(in: &cancellables)
    }

    // MARK: - Gestures
        
    private func setupLabelTapGesture(_ label: UILabel) {
        let tapGesutre = UITapGestureRecognizer(target: self, action: #selector(handleLabelTapGesture(_:)))
        
        label.addGestureRecognizer(tapGesutre)
        label.isUserInteractionEnabled = true
    }

    // MARK: - Actions
    
    @IBAction private func textFieldTextDidChange(_ sender: UITextField) {
        sender.text = model.manipulator.manipulate(sender.text ?? "")
        
        model.amountPublisher.send(sender.text)
    }
        
    @objc
    private func handleLabelTapGesture(_ gesture: UITapGestureRecognizer) {
        guard let gestureView = gesture.view as? UILabel else {
            return
        }
        
        showMenuContext(label: gestureView)
    }

    private func showMenuContext(label: UILabel) {
        selectedLabelIndex = label.tag

        var actions: [ContextMenuAction] = []
        actions.append(ContextMenuAction(content: .text(title: "Use Balance", accessibilityLabel: "Use Balance"), action: { [weak self] in
            if let self {
                self.useCryptoBalance(label: label)
            }
        }))
        
        let node = ASDisplayNode(viewBlock: {
            return label
        })
        let contextMenuController = ContextMenuController(actions: actions)
        model.contextMenuPublisher.send((contextMenuController, node, label.bounds))
    }

    @objc
    private func useCryptoBalance(label: UILabel) {
        guard let info = model.provideAmountCorrectValue(for: selectedLabelIndex) else { return }
        
        let isCryptoSelected = model.amountTypeSegmentedControlViewModel.selectedIndex.value == 0
        let amount = isCryptoSelected ? info.cryptoPrice : info.fiatPrice
        
        amountTextField.text = amount
        model.amountPublisher.send(amount)
    }

    @objc
    private func useCashBalance(label: UILabel) {
        guard let info = model.provideAmountCorrectValue(for: selectedLabelIndex) else { return }

        amountTextField.text = info.fiatPrice
        model.amountPublisher.send(info.fiatPrice)
    }
}

extension BuyOrSellCryptoStackView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return model.textChecker.canChange(textField, shouldChangeCharactersIn: range, replacementString: string)
    }
}
