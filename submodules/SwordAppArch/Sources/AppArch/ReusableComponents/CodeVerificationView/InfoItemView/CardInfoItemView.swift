//
//  CardInfoItemView.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 15.02.23.
//

import UIKit

final class CardInfoItemView: SetupableView {
    // MARK: - IBOutlets
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var contentLabel: UILabel!
    @IBOutlet private weak var copyButton: UIButton!
    
    // MARK: - Properties
    
    private var model: CardInfoItemViewModel!
    
    // MARK: - Setup UI
    
    func setup(with model: CardInfoItemViewModel) {
        self.model = model
        
        contentLabel.text = model.info.content
        
        setupTitleLabel()
        setupCopyButton()
    }
    
    private func setupTitleLabel() {
        guard let title = model.info.title else {
            titleLabel.isHidden = true
            
            return
        }
        
        titleLabel.isHidden = false
        titleLabel.text = title
    }
    
    private func setupCopyButton() {
        guard model.info.isCopiable else {
            copyButton.isHidden = true
            
            return
        }
        
        copyButton.isHidden = false
    }
    
    private func updateCopyButtonState(isCopied: Bool) {
        let imageName = isCopied ? Constants.AssetName.Common.check : Constants.AssetName.Common.copy
        
        copyButton.isUserInteractionEnabled = !isCopied
        copyButton.setImage(UIImage(systemName: imageName), for: .normal)
    }

    // MARK: - Actions
    
    @IBAction private func copyButtonTouchUp(_ sender: UIButton) {
        UIPasteboard.general.string = model.info.content
        
        updateCopyButtonState(isCopied: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [ weak self ] in
            self?.updateCopyButtonState(isCopied: false)
        }
    }
}
