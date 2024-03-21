//
//  FooterLoadingView.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 11.07.22.
//

import UIKit

final class FooterLoadingView: SetupableView {

    // MARK: - IBOutlets

    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var loadingLabel: UILabel!

    // MARK: - Setup UI

    func setup(with model: SetupModel) {
        loadingLabel.text = "\(Constants.Localization.Common.loading)..."
    }
}

extension FooterLoadingView {
    struct SetupModel {
        
    }
}
