//
//  SegmentedControl.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 26.12.22.
//

import UIKit
import Combine

final class SegmentedControl: SetupableView {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var backgroundView: UIView!
    @IBOutlet private weak var borderedSegmenView: UIView!
    @IBOutlet private weak var contentHolderStackView: UIStackView!
    @IBOutlet private weak var borderedSegmenViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet private weak var borderedSegmenViewLeadingConstraint: NSLayoutConstraint!
    
    // MARK: - Properties

    private var model: SegmentedControlSetupModel!
    private var cancellables: Set<AnyCancellable> = []

    private var widthConstraint: CGFloat {
        return (frame.width - 2) / CGFloat(model.setupModels.count)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        borderedSegmenViewWidthConstraint.constant = widthConstraint
    }

    // MARK: - Setup UI

    func setup(with model: SegmentedControlSetupModel) {
        self.model = model
        
        backgroundView.setCornerRadius(model.prepareCornerRadius(for: backgroundView.frame.height))
        backgroundView.backgroundColor = model.style == .light ? theme.colors.lightBlue2 : .clear
        borderedSegmenView.backgroundColor = model.style == .light ? theme.colors.mainWhite : theme.colors.textColor

        setupSegments()
        setupBorderedView()
        bindToSelectedIndex()
    }
    
    private func setupBorderedView() {
        borderedSegmenView.setCornerRadius(model.prepareCornerRadius(for: borderedSegmenView.frame.height))
    }
    
    private func setupSegments() {
        let segmentItems: [SegmentedControllItem] = model.setupModels.compactMap {
            guard let item = SegmentedControllItem.loadFromNib() else { return nil }
            
            item.setup(with: $0)
            
            return item
        }
        
        segmentItems.forEach { contentHolderStackView.addArrangedSubview($0) }
    }
    
    // MARK: - Binding
    private var needToAnimate = false
    
    private func bindToSelectedIndex() {
        model.selectedIndex
            .sink { [ weak self ] selectedIndex in
                guard let self else { return }

                let additionalSpace: CGFloat

                if selectedIndex == 0 {
                    additionalSpace = model.style == .light ? 4 : 0
                } else if selectedIndex == self.model.models.count - 1 {
                    additionalSpace = -(model.style == .light ? 4 : 0)
                } else {
                    additionalSpace = 0
                }

                guard model.isAnimatable else {
                    self.borderedSegmenViewLeadingConstraint.constant = CGFloat(selectedIndex) * self.widthConstraint + additionalSpace
                    self.model.setupModels.enumerated().forEach { $0.element.setupModel.isSelected.send(selectedIndex == $0.offset)}

                    return
                }

                updateItemsState(selectedIndex: selectedIndex, isBeforAnimation: true)
                if self.needToAnimate {
                    self.borderedSegmenViewLeadingConstraint.constant = CGFloat(selectedIndex) * widthConstraint + additionalSpace
                    UIView.animate(withDuration: 0.5) {
                        self.layoutIfNeeded()
                    } completion: { _ in
                        self.updateItemsState(selectedIndex: selectedIndex, isBeforAnimation: false)
                    }
                } else {
                    self.needToAnimate = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self.borderedSegmenViewLeadingConstraint.constant = CGFloat(selectedIndex) * self.widthConstraint + additionalSpace
                    }
                    self.updateItemsState(selectedIndex: selectedIndex, isBeforAnimation: false)
                }
            }
            .store(in: &cancellables)
    }
    
    private func updateItemsState(selectedIndex: Int, isBeforAnimation: Bool) {
        if isBeforAnimation {
            self.model.setupModels.enumerated()
                .filter { $0.offset != selectedIndex }
                .forEach { $0.element.setupModel.isSelected.send(false) }
        } else {
            self.model.setupModels.enumerated()
                .filter { $0.offset == selectedIndex }
                .forEach { $0.element.setupModel.isSelected.send(true) }
        }
    }
}
