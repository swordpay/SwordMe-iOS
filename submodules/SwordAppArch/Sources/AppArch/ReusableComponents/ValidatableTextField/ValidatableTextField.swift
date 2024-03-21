//
//  ValidatableTextField.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 31.05.22.
//

import UIKit
import Combine

final class ValidatableTextField: SetupableView {
    typealias SetupModel = ValidatableTextFieldModel

    // MARK: - IBOutlets
    
    @IBOutlet private weak var textFieldSeparatorView: UIView!
    @IBOutlet private(set) weak var textField: UITextField!
    @IBOutlet private weak var errorMessageLabel: UILabel!

    private lazy var secureTextButton: UIButton = {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(imageName: Constants.AssetName.InputText.hiddenSecureText), for: .normal)
        button.addTarget(self, action: #selector(showTextInputButtonTouchUp(_:)), for: .touchUpInside)

        return button
    }()
    
    private lazy var clearButton: UIButton = {
        let button = UIButton()
        
        button.tintColor = theme.colors.tintGray
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(imageName: Constants.AssetName.InputText.clearText), for: .normal)
        button.imageView?.tintColor = theme.colors.tintGray
        button.addTarget(self, action: #selector(clearTextButtonTouchUp(_:)), for: .touchUpInside)

        return button
    }()

    // MARK: - Properties

    private var cancellables: Set<AnyCancellable> = []
    private var model: ValidatableTextFieldModel!

    // MARK: - Setup UI

    func setup(with model: ValidatableTextFieldModel) {
        self.model = model

        setupTextField()
        
        bindToPrefix()
        bindToPlaceholder()
        bindToKeyboardType()
        bindToExternalText()
        bindToExternalValidation()
        bindToMakeFirstResponder()
        bindToResetTextFieldPublisher()
        
        guard let text = model.text.value,
              !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        validateText(text)
    }
    
    private func setupTextField() {
        textField.delegate = self

        textField.smartQuotesType = .no
        textField.returnKeyType = model.returnKeyType
        textField.text = model.text.value
        textField.textColor = theme.colors.textColor
        textField.font = theme.fonts.semibold(ofSize: 22, family: .poppins)
        textField.attributedPlaceholder = model.attributedPlaceholder

        textField.setCornerRadius()
        textField.backgroundColor = .clear

        configureTextFieldRightButton()
        configureUI(for: .inactive)

        if !model.isEditable {
            setupUIForNotEditableState()
        }
        
        if model.isKeyboardNumerical {
            textField.setupKeyboardToolbar()
        }
    }

    private func setupUIForNotEditableState() {
        textField.textColor = theme.colors.textColor.withAlphaComponent(0.38)
        textField.isUserInteractionEnabled = false
    }

    private func setupPrefixIfNeeded(prefix: String?) {
        guard let prefix else {
            textField.leftView = nil
            textField.leftViewMode = .never

            return
        }
        
        let prefixLabel = UILabel()
        
        prefixLabel.textColor = theme.colors.tintGray
        prefixLabel.font = theme.fonts.regular(ofSize: 22, family: .poppins)
        
        prefixLabel.text = prefix
        
        textField.leftViewMode = .always
        textField.leftView = prefixLabel
    }

    private func setupLeadingOffset() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))

        view.backgroundColor = .clear
        textField.leftViewMode = .always
        textField.leftView = view
    }

    private func configureTextFieldRightButton() {
        textField.rightViewMode = .always
        textField.rightView = prepareRightView()
    }

    private func prepareRightView() -> UIView {
        let view  = UIView()
        let button = model.isSecureTextEntryEnabled ? secureTextButton : clearButton
        let secureTextButtonImageName = Constants.AssetName.InputText.hiddenSecureText
        let text = model.text.value?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        textField.isSecureTextEntry = model.isSecureTextEntryEnabled
        secureTextButton.setImage(UIImage(named: secureTextButtonImageName), for: .normal)

        view.isHidden = !(model.isSecureTextEntryEnabled || !text.isEmpty)
        view.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(button)
        secureTextButton.addBorderConstraints(constraintSides: .all)
        
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: 25),
            view.widthAnchor.constraint(equalToConstant: 25)
        ])

        return view
    }
    
    private func updateSeparatorColor(isEditing: Bool) {
        guard !isEditing else {
            textFieldSeparatorView.backgroundColor = theme.colors.textBlue
            
            return
        }
        
        let isTextValid = model.isValid.value || (textField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        let color = isTextValid ? theme.colors.lightGray2 : theme.colors.mainRed
        
        textFieldSeparatorView.backgroundColor = color
    }
    
    // MARK: - Binding
    
    private func bindToExternalValidation() {
        model.externalValidationPublisher
            .sink { [ weak self ] result in
                self?.handleValidationResult(result, isEditing: false)
            }
            .store(in: &cancellables)
    }

    private func bindToExternalText() {
        model.externalTextPublisher
            .sink { [ weak self ] text in
                self?.validateText(text)
            }
            .store(in: &cancellables)
    }

    private func bindToMakeFirstResponder() {
        model.makeFirstResponderPublisher
            .sink { [ weak self ] isFirstResponder in
                if isFirstResponder {
                    self?.textField.becomeFirstResponder()
                } else {
                    self?.textField.resignFirstResponder()
                }
            }
            .store(in: &cancellables)
    }

    private func bindToPlaceholder() {
        model.placeholder
            .sink { [ weak self ] _ in
                guard let self else { return }

                self.textField.attributedPlaceholder = self.model.attributedPlaceholder
            }
            .store(in: &cancellables)
    }
    
    private func bindToKeyboardType() {
        model.keyboardType
            .sink { [ weak self ] keyboardType in
                guard let self else { return }

                self.textField.keyboardType = keyboardType
            }
            .store(in: &cancellables)
    }

    private func bindToPrefix() {
        model.prefix
            .sink { [ weak self ] prefixText in
                self?.setupPrefixIfNeeded(prefix: prefixText)
            }
            .store(in: &cancellables)
    }
    
    private func bindToResetTextFieldPublisher() {
        model.resetTextFieldPublisher
            .sink { [ weak self ] in
                guard let self else { return }
                
                self.textField.text = nil
                self.model.isValid.send(false)
                self.configureUI(for: .active)
            }
            .store(in: &cancellables)
    }

    // MARK: - Actions

    @IBAction private func textFieldTextDidChange(_ sender: UITextField) {
        validateText(sender.text)
    }
    
    @objc
    private func showTextInputButtonTouchUp(_ sender: UIButton) {
        textField.isSecureTextEntry.toggle()
        let secureTextButtonImageName = textField.isSecureTextEntry ? Constants.AssetName.InputText.hiddenSecureText
                                                                    : Constants.AssetName.InputText.secureText
        
        secureTextButton.setImage(UIImage(named: secureTextButtonImageName), for: .normal)
    }
    
    @objc
    private func clearTextButtonTouchUp(_ sender: UIButton) {
        textField.text = ""
        model.text.send("")
        
        handleTextChange("", isEditing: false)
        updateSecureTextButtonVisibility(text: nil)
    }
}

// MARK: - Configure UI For State

private extension ValidatableTextField {
    enum State {
        case active
        case inactive
        case error(String)
    }

    func configureUI(for state: State) {
        switch state {
        case .active:
            configureUIForActiveState()
        case .inactive:
            configureUIForInactiveState()
        case .error(let message):
            configureUIForErrorState(with: message)
        }
    }

    func configureUIForActiveState() {
        textFieldSeparatorView.backgroundColor = theme.colors.textBlue
        textField.textColor = theme.colors.textColor
        animateStateChange(alpha: 0)
    }

    func configureUIForInactiveState() {
        textFieldSeparatorView.backgroundColor = theme.colors.lightGray2
        textField.textColor = theme.colors.textColor
        animateStateChange(alpha: 0)
    }

    func configureUIForErrorState(with message: String) {
        guard !message.isEmpty else {
            configureUIForActiveState()
            
            return
        }

        textFieldSeparatorView.backgroundColor = theme.colors.mainRed
        textField.textColor = theme.colors.mainRed
        errorMessageLabel.text = "\(message)"
        animateStateChange(alpha: 1)
    }

    func animateStateChange(alpha: CGFloat) {
        UIView.animate(withDuration: 0.25) {
            self.errorMessageLabel.alpha = alpha
        }
    }

    @discardableResult
    func handleTextChange(_ text: String?, isEditing: Bool) -> String? {
        let validationResult: (state: TextValidationResultState, text: String?) = model.validator.validate(text)

        return handleValidationResult(validationResult, isEditing: isEditing)
    }

    @discardableResult
    private func handleValidationResult(_ result: Constants.Typealias.TextValidationResult,
                                        isEditing: Bool) -> String? {
        switch result.0{
        case .success:
            let state: ValidatableTextField.State = isEditing ? .active : .inactive

            configureUI(for: state)
        case .failure(let message):
            configureUI(for: .error(message))
        }

        model.text.send(result.1)

        return result.1
    }

    private func updateSecureTextButtonVisibility(text: String?) {
        guard !model.isSecureTextEntryEnabled else {
            textField.rightView?.isHidden = false
            
            return
        }
        
        guard let text,
              !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            textField.rightView?.isHidden = true
            
            return
        }

        textField.rightView?.isHidden = false
    }
    
    private func validateText(_ text: String?) {
        var mainText: String = text ?? ""

        if let manipulator = model.manipulator {
            mainText = manipulator.manipulate(mainText)
        }

        let validatedText = handleTextChange(mainText, isEditing: false)

        textField.text = validatedText

        updateSeparatorColor(isEditing: false)

        updateSecureTextButtonVisibility(text: mainText)
        model.text.send(validatedText)
    }
}

extension ValidatableTextField: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        model.didTextEditBegin.send(())
        configureUIForActiveState()
        updateSeparatorColor(isEditing: true)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        validateText(textField.text)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        model.nextTextFieldModel?.makeFirstResponderPublisher.send(true)
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentString = (textField.text ?? "") as NSString
        let newString = currentString.replacingCharacters(in: range, with: string)

        guard case let .lenght(count) = model.inputLimit else {
            guard let textChecker = model.textChecker else { return true }
            return textChecker.canChange(textField, shouldChangeCharactersIn: range, replacementString: string)
        }

        return newString.count <= count
    }
}
