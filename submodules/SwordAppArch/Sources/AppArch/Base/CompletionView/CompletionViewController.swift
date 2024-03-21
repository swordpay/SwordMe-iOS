//
//  CompletionViewController.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 27.06.22.
//

import UIKit

final class CompletionViewController: GenericStackViewController<CompletionViewModel, CompletionStackView> {
    // MARK: - Properties

    override var shouldRespectSafeArea: Bool { return false }
    override var shouldEmbedInScrollView: Bool { return false }
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDismissButtonIfNeeded()
    }
    
    // MARK: - Setup UI

    private func setupDismissButtonIfNeeded() {
        guard viewModel.dismissAction != nil  else {
            navigationItem.backBarButtonItem = nil

            return
        }
        
        let image = UIImage(systemName: Constants.AssetName.SystemIcon.circledClose)
        let dismissBarButton = UIBarButtonItem(image: image,
                                               style: .plain,
                                               target: self,
                                               action: #selector(dismissButtonHandler))

        dismissBarButton.tintColor = theme.colors.mainWhite
        navigationItem.rightBarButtonItem = dismissBarButton
    }

    // MARK: - Actions

    @objc
    func dismissButtonHandler() {
        viewModel.dismissAction?()
    }
}
