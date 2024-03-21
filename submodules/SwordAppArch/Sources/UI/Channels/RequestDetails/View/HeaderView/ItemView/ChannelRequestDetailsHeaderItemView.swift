//
//  ChannelRequestDetailsHeaderItemView.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 28.12.22.
//

import UIKit

final class ChannelRequestDetailsHeaderItemView: SetupableView {

    // MARK: - IBOutlets
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var dashedSeparatorView: UIView!

    // MARK: - Setup UI
    
    func setup(with model: ChannelRequestDetailsHeaderItemViewModel) {
        titleLabel.font = theme.fonts.regular(ofSize: 17, family: .rubik)
        titleLabel.text = model.title
        descriptionLabel.attributedText = model.attributedDescription
    }
}
