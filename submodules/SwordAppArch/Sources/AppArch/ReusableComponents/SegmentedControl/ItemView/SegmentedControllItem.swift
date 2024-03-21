//
//  SegmentedControllItem.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 26.12.22.
//

import UIKit
import Combine

final class SegmentedControllItem: SetupableView {
    // MARK: - IBOutlets
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var iconImageView: UIImageView!
    
    // MARK: - Properties
    
    private var model: SegmentedControllItemSetupModel!
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Setup UI
    
    func setup(with model: SegmentedControllItemSetupModel) {
        self.model = model
        
        titleLabel.text = model.setupModel.title
        iconImageView.tintColor = theme.colors.textColor.withAlphaComponent(0.8)
        
        setupIcon()
        setupTapGesture()
        bindToSelectedState()
    }
    
    private func setupIcon() {
        guard let imageName = model.setupModel.imageName else {
            iconImageView.isHidden = true
            
            return
        }
        
        iconImageView.isHidden = false
        iconImageView.image = UIImage(named: imageName)
    }

    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(mainViewTapHandler))
        
        isUserInteractionEnabled = true
        addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Binding
    
    private func bindToSelectedState() {
        model.setupModel.isSelected
            .sink { [ weak self ] isSelected in
                guard let self else { return }

                let titleFont = self.model.font
                let textColor: UIColor = self.prepareTextColor(isSelected: isSelected)
                let tintColor: UIColor = isSelected ? self.theme.colors.gradientDarkBlue
                                                    : self.theme.colors.lightGray2
                
                self.titleLabel.font = titleFont
                self.titleLabel.textColor = textColor
                self.iconImageView.image = self.iconImageView.image?.withRenderingMode(.alwaysTemplate)
                self.iconImageView.tintColor = tintColor
            }
            .store(in: &cancellables)
    }
    
    private func prepareTextColor(isSelected: Bool) -> UIColor {
        if isSelected {
            return model.style == .light ? theme.colors.textColor : theme.colors.mainWhite
        } else {
            return model.style == .light ? theme.colors.mainGray4 : theme.colors.textColor
        }
    }

    // MARK: - Action
    
    @objc
    private func mainViewTapHandler() {
        model.selectionPublisher.send(())
    }
}
