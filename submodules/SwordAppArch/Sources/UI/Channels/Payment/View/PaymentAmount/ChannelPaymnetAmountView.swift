//
//  ChannelPaymnetAmountView.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 22.05.23.
//

import UIKit
import Combine

final class ChannelPaymnetAmountView: SetupableView {
    // MARK: - IBOutlets
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var cryptoInfoHolderParentView: UIView!
    @IBOutlet private weak var cryptoInfoHolderView: UIView!
    @IBOutlet private weak var amountTextField: UITextField!
    @IBOutlet private weak var amountTypePickerButton: UIButton!
    @IBOutlet private weak var separatorView: UIView!
    @IBOutlet private weak var dropDownImageView: UIImageView!
    @IBOutlet private weak var editAmountButton: UIButton!
    @IBOutlet private weak var exchangeErrorLabel: UILabel!
    
    // MARK: - Properties
    
    private var model: ChannelPaymnetAmountViewModel!
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Setup UI
    
    func setup(with model: ChannelPaymnetAmountViewModel) {
        self.model = model
        
        amountTextField.attributedPlaceholder = model.attributedPlaceholder
        exchangeErrorLabel.text = "Crypto Exchange Rates Unavailable"
        titleLabel.text = model.title

        setupCryptoInfoView()
        setupAmountTextField()
        setupDropdownImageTapgesture()
        setupCryptoInfoHolderViewTapHandler()
        
        bindToAmount()
        bindToAmountType()
        bindToCanEditAmount()
        bindToSelectedCrytpo()
        bindToCanChangePaymentMethods()
    }
    
    private func setupCryptoInfoView() {
        guard let view = ChannelPaymnetAmountCryptoInfoView.loadFromNib() else {
            cryptoInfoHolderParentView.isHidden = true
            
            return 
        }
        
        cryptoInfoHolderParentView.isHidden = model.cryptoInfoViewModel.cryptoModel.value == nil
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setup(with: model.cryptoInfoViewModel)
        cryptoInfoHolderView.addSubview(view)
        view.addBorderConstraints(constraintSides: .all)
    }
    
    private func setupCryptoInfoHolderViewTapHandler() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(cryptoPickerTapHandler))
        
        cryptoInfoHolderView.addGestureRecognizer(gesture)
        cryptoInfoHolderView.isUserInteractionEnabled = true
    }

    private func setupAmountTextField() {
        amountTextField.delegate = self
        amountTextField.setupKeyboardToolbar()
        amountTextField.isUserInteractionEnabled = !model.isPaying
    }

    private func updateUI(selectedCrypto: ChannelPaymnetAmountViewModel.CryptoInfo?) {
        let isCryptoSelected = selectedCrypto != nil
        let amountAbbreviation = isCryptoSelected && model.amountType.value == .crypto ? "C" : Constants.euro
        let canChangeAmountType = !model.isPaying && isCryptoSelected
        
        amountTypePickerButton.setTitle(amountAbbreviation, for: .normal)
        dropDownImageView.isHidden = !canChangeAmountType
        amountTypePickerButton.isUserInteractionEnabled = canChangeAmountType
        cryptoInfoHolderParentView.isHidden = !isCryptoSelected
    }

    private func updateUI(amountType: AmountType) {
        let amountAbbreviation = amountType == .crypto ? "C" : Constants.euro
        
        amountTypePickerButton.setTitle(amountAbbreviation, for: .normal)
        model.manipulator.maximumFractionDigits = model.precistionCount
        model.textChecker.precision = model.precistionCount
        
        amountTextField.text = model.manipulator.manipulate(amountTextField.text ?? "")
        
        model.amount.send(amountTextField.text)
    }
    
    private func setupDropdownImageTapgesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dropdownImageTapHandler))
        
        dropDownImageView.isUserInteractionEnabled = true
        dropDownImageView.addGestureRecognizer(gesture)
    }

    private func setupExchangeLabel() {
        guard model.isPaying && model.amount.value == nil else {
            exchangeErrorLabel.isHidden = true
            
            return
        }
        
        exchangeErrorLabel.isHidden = false
    }
    
    // MARK: - Binding
    
    private func bindToAmount() {
        model.amount
            .sink { [ weak self ] amount in
                guard let self else { return }
                
                self.amountTextField.text = self.model.manipulator.manipulate(amount ?? "")
                self.setupExchangeLabel()
            }
            .store(in: &cancellables)
    }
    
    private func bindToSelectedCrytpo() {
        model.selectedCrypto
            .sink { [ weak self ] selectedCrypto in
                self?.model.cryptoInfoViewModel.cryptoModel.send(selectedCrypto)
                self?.updateUI(selectedCrypto: selectedCrypto)
            }
            .store(in: &cancellables)
    }

    private func bindToCanChangePaymentMethods() {
        model.canChangePaymentMethods
            .sink { [ weak self ] canChange in
                self?.dropDownImageView.isHidden = !canChange
            }
            .store(in: &cancellables)
    }
    
    private func bindToAmountType() {
        model.amountType
            .sink { [ weak self ] amountType in
                self?.updateUI(amountType: amountType)
            }
            .store(in: &cancellables)
    }
    
    private func bindToCanEditAmount() {
//        model.canEditAmount
//            .sink { [ weak self ] canEditAmount in
//                self?.editAmountButton.isHidden = !canEditAmount
//            }
//            .store(in: &cancellables)
    }

    // MARK: - Actions
    
    @IBAction private func textFieldTextDidChange(_ sender: UITextField) {
        sender.text = model.manipulator.manipulate(sender.text ?? "")
        
        model.amount.send(sender.text)
    }
    
    @IBAction private func amountTypeButtonTouchUp(_ sender: UIButton) {
        model.amountTypePickerPublisher.send(())
    }
    
    @IBAction private func editAmountButtonTouchUp(_ sender: UIButton) {
        model.editAmountButtonPublisher.send(())
    }

    @objc
    private func cryptoPickerTapHandler() {
        model.cryptoPickerChangePusblisher.send(())
    }
    
    @objc
    private func dropdownImageTapHandler() {
        model.amountTypePickerPublisher.send(())
    }
}

extension ChannelPaymnetAmountView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return model.textChecker.canChange(textField, shouldChangeCharactersIn: range, replacementString: string)
    }
}
