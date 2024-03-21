//
//  CodeVerificationItemView.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 07.05.23.
//

import UIKit
import Combine

final class CodeVerificationItemView: SetupableView {
    // MARK: - IBOutlets
    
    @IBOutlet private(set) weak var codeTextField: DeleteActionTrackingTextField!
    @IBOutlet private weak var underlineView: UIView!
    
    // MARK: - Properties
    
    private var model: CodeVerificationItemViewModel!
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Setup UI
    
    func setup(with model: CodeVerificationItemViewModel) {
        self.model = model
        codeTextField.text = model.currentText
        codeTextField.setupKeyboardToolbar()

        bindToTextToUpdate()
    }
    
    // MARK: - Binding
    
    private func bindToTextToUpdate() {
        model.textToUpdatePublisher
            .sink { [ weak self ] text in
                guard let self else { return }

                self.codeTextField.text = text
                
                let underlineViewBackgroundColor = text != nil ? self.theme.colors.textColor : self.theme.colors.lightGray3

                self.underlineView.backgroundColor = underlineViewBackgroundColor
            }
            .store(in: &cancellables)
    }
}
