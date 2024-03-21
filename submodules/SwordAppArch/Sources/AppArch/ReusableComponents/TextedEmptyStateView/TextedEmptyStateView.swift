//
//  TextedEmptyStateView.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 04.05.23.
//

import UIKit
import Combine

final class TextedEmptyStateView: SetupableView {
    // MARK: - IBOutlets
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var actionButton: UIButton!
    
    // MARK: - Properties
    
    private var model: TextedEmptyStateViewModel!
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Setup UI
    
    func setup(with model: TextedEmptyStateViewModel) {
        self.model = model
        
        imageView.isHidden = !model.hasImage
        actionButton.titleLabel?.font = theme.fonts.bold(ofSize: 16, family: .poppins)

        bindToTitle()
        bindToDescription()
        bindToActionButtonTitle()
    }
        
    // MARK: - Binding
    
    private func bindToTitle() {
        model.title
            .sink { [ weak self ] title in
                self?.titleLabel.text = title
            }
            .store(in: &cancellables)
    }
    
    private func bindToActionButtonTitle() {
        model.actionTitle
            .sink { [ weak self ] title in
                guard let self,
                      let title else {
                    self?.actionButton.isHidden = true
                    
                    return
                }
                
                self.actionButton.setTitle(title, for: .normal)
                self.actionButton.isHidden = false
            }
            .store(in: &cancellables)
    }

    private func bindToDescription() {
        model.description
            .sink { [ weak self ] description in
                guard let self,
                      let description else {
                    self?.descriptionLabel.isHidden = true
                    
                    return
                }
                
                self.descriptionLabel.text = description
                self.descriptionLabel.isHidden = false
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Actions
    
    @IBAction private func actionButtonTouchUp(_ sender: UIButton) {
        model.actionTapHandler.send(())
    }
}
