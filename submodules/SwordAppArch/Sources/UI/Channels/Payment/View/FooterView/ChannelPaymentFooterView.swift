//
//  ChannelPaymentFooterView.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 27.12.22.
//

import UIKit
import Combine

final class ChannelPaymentFooterView: SetupableView {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var notesTextField: UITextField!
    @IBOutlet private weak var requestButton: RoundButton!
    @IBOutlet private weak var payButton: RoundButton!

    @IBOutlet private weak var holderStackViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var actionHolderViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Properties
    
    private var model: ChannelPaymentFooterViewModel!
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Setup UI
    
    func setup(with model: ChannelPaymentFooterViewModel) {
        self.model = model
        
        holderStackViewLeadingConstraint.constant = UIScreen.hasSmallScreen ? 8 : 16
        actionHolderViewHeightConstraint.constant = UIScreen.hasSmallScreen ? 36 : 40
        setupNotesTextField()
        setupButtonUI(payButton, title: Constants.Localization.Common.send)
        setupButtonUI(requestButton, title: Constants.Localization.Common.request)
        
        if model.isPaying {
            requestButton.isHidden = true
            payButton.isHidden = false
        } else {
            payButton.isHidden = !model.isSendActionAvailable
            requestButton.isHidden = false
        }
    }
        
    private func setupButtonUI(_ button: RoundButton, title: String) {
        button.titleLabel?.font = theme.fonts.font(style: .smallButtonTitle, family: .poppins, weight: .bold)
        button.cornerRadius = button.frame.height / 2
        button.setTitle(title, for: .normal)
    }

    private func setupNotesTextField() {
        notesTextField.setCornerRadius(10)
        notesTextField.delegate = self
        notesTextField.attributedPlaceholder = NSAttributedString(string: Constants.Localization.Channels.notesPlaceholder,
                                                                  attributes: [.font: theme.fonts.regular(ofSize: 16, family: .poppins),
                                                                               .foregroundColor: theme.colors.tintGray])
        setupNoteOffsets()
    }

    private func setupNoteOffsets() {
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))

        leftView.backgroundColor = .clear
        notesTextField.leftViewMode = .always
        notesTextField.leftView = leftView
        
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))

        rightView.backgroundColor = .clear
        notesTextField.rightViewMode = .always
        notesTextField.rightView = rightView
    }

    // MARK: - Actions
    
    @IBAction private func textFieldTextDidChange(_ sender: UITextField) {
        model.note.send(sender.text)
    }
    
    @IBAction private func payButtonTouchUp(_ sender: UIButton) {
        model.transactionButtonHandler.send(false)
    }

    @IBAction private func reqeustButtonTouchUp(_ sender: UIButton) {
        model.transactionButtonHandler.send(true)
    }
}

extension ChannelPaymentFooterView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentString = (textField.text ?? "") as NSString
        let newString = currentString.replacingCharacters(in: range, with: string)

        return newString.trimmingCharacters(in: .whitespacesAndNewlines).count <= 200
    }
}
