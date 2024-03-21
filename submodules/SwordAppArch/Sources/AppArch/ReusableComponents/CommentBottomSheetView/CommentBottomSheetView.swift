//
//  CommentBottomSheetView.swift.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 29.12.22.
//

import UIKit

final class CommentBottomSheetView: SetupableView {
    // MARK: - IBOutlets
    
    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var rightSideButton: UIButton!
    @IBOutlet private weak var grabberView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var commentTextField: UITextField!
    
    // MARK: - Properties
    
    private var model: CommentBottomSheetViewModel!
    
    // MARK: - Setup UI
    
    func setup(with model: CommentBottomSheetViewModel) {
        self.model = model
        
        titleLabel.text = model.title
        cancelButton.setTitle(Constants.Localization.Common.cancel, for: .normal)
        rightSideButton.setTitle(model.rightSideButtonTitle, for: .normal)
        commentTextField.attributedPlaceholder = model.commentTextFieldAttributedPlaceholder
        commentTextField.delegate = self

        setupDescriptionLabel()
    }
    
    private func setupDescriptionLabel() {
        guard let description = model.description else {
            descriptionLabel.isHidden = true
            
            return
        }
        
        descriptionLabel.text = description
    }
    
    // MARK: - Actions
    
    @IBAction private func cancelButtonTouchUp(_ sender: UIButton) {
        model.cancelButtonPublisher.send(())
    }
    
    @IBAction private func rightSideButtonTouchUp(_ sender: UIButton) {
        model.rightSideButtonPublisher.send(())
    }
}

extension CommentBottomSheetView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}
