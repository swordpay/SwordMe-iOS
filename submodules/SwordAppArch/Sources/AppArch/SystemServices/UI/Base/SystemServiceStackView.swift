//
//  SystemServiceStackView.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 18.04.22.
//

import UIKit

final class SystemServiceStackView: SetupableStackView {

    // MARK: - IBOutlets

    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var enableButtonHolderBackgroundView: UIView!
    @IBOutlet private weak var enableButtonHolderView: UIView!

    // MARK: - Properties

    var model: SetupModel!

    // MARK: - Setup UI

    func setup(with model: SetupModel) {
        self.model = model
        setupEnableButton()

        setupLabel(titleLabel, with: model.info.title)
        setupLabel(descriptionLabel, with: model.info.description)
        iconImageView.image = UIImage(named: model.info.iconName)
        
        titleLabel.font = theme.fonts.bold(ofSize: 21, family: .rubik)
        descriptionLabel.font = theme.fonts.regular(ofSize: 17, family: .rubik)
    }
    
    private func setupLabel(_ label: UILabel, with text: String) {
        guard !text.isEmpty else {
            label.isHidden = true
            
            return
        }

        label.text = text
    }

    private func setupEnableButton() {
        guard model.info.hasAction else {
            enableButtonHolderView.isHidden = true

            return
        }

        let button = GradientedButton()
        let model = GradientedButtonModel(title: Constants.Localization.SystemService.actionTitle,
                                          hasBorders: false,
                                          isActive: true,
                                          action: model.info.action)

        button.setup(with: model)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setCornerRadius()
        enableButtonHolderView.addSubview(button)
        button.addBorderConstraints(constraintSides: .all)
    }

    // MARK: - Handlers

    @IBAction private func handleEnableButtonTouchUp(_ sender: UIButton) {
        model.info.action()
    }
}

extension SystemServiceStackView {
    struct SetupModel {
        struct UIConfiguration {
            let enableButtonCornerRadius: CGFloat = 6
        }

        var uiConfig: UIConfiguration {
            return UIConfiguration()
        }

        let info: SystemServicePresentationModel
    }
}
