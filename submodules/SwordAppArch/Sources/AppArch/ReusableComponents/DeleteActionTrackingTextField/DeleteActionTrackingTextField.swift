//
//  DeleteActionTrackingTextField.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 05.12.22.
//

import UIKit

protocol DeleteActionTrackingTextFieldDelegate: NSObject {
    func didTapDeletedInEmptyTextField(_ textField: UITextField) -> Void
}

class DeleteActionTrackingTextField: UITextField {
    weak var deleteDelegate: DeleteActionTrackingTextFieldDelegate?

    override func deleteBackward() {
        if let text = text, text.isEmpty {
            self.deleteDelegate?.didTapDeletedInEmptyTextField(self)
        }

        super.deleteBackward()
    }
}
