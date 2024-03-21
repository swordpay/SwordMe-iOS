//
//  ScreenEmptyStateView.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 21.04.22.
//

import UIKit

final class ScreenEmptyStateView: SetupableView {
    typealias SetupModel = ScreenEmptyStateModel

    // MARK: - IBOutlets

    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var actionButton: UIButton!
    
    // MARK: - Properties
    
    private var model: ScreenEmptyStateModel!

    // MARK: - Setup UI

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let location = actionButton.convert(point, from: self)

        if actionButton.point(inside: location, with: nil) {
            return actionButton
        }

        return nil
    }

    func setup(with model: ScreenEmptyStateModel) {
        self.model = model

        iconImageView.image = UIImage(named: model.iconName)
        textLabel.text = model.text
        
        setupActionButton()
    }
    
    private func setupActionButton() {
        guard let action = model.action else { return }
        actionButton.isHidden = false
        actionButton.setTitle(action.title, for: .normal)
        textLabel.numberOfLines = 1
    }

    // MARK: - IBActions
    
    @IBAction private func actionButtonTouchUp(_ sender: UIButton) {
        model.action?.handler()
    }
}
