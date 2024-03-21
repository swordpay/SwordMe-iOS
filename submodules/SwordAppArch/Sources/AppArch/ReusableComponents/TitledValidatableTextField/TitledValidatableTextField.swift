//
//  TitledValidatableTextField.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 14.02.23.
//

import UIKit

final class TitledValidatableTextField: SetupableView {
    // MARK: - IBOutlets
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var textFieldHolderView: UIView!
    
    // MARK: - Properties
    
    private var model: TitledValidatableTextFieldModel!
    
    // MARK: - Setup UI
    
    func setup(with model: TitledValidatableTextFieldModel) {
        self.model = model
        
        titleLabel.text = model.title
        setupTextField()
    }
    
    private func setupTextField() {
        guard let textField = ValidatableTextField.loadFromNib() else { return }
        
        textField.setup(with: model.textFieldModel)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textFieldHolderView.addSubview(textField)
        textField.addBorderConstraints(constraintSides: .all)
    }
}
