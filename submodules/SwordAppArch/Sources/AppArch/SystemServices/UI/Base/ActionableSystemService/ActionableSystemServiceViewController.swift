//
//  ActionableSystemServiceViewController.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 06.06.22.
//

import Foundation

class ActionableSystemServiceViewController: SystemServiceViewController<ActionableSystemServiceViewModel> {

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNotifications()
    }

    func setupNotifications() {

    }

    func completionHandler() {
        if viewModel.shouldDismissBeforeCompletion {
            self.dismiss(animated: true) { [weak self] in
                self?.viewModel.requestCompletion?()
            }
        } else {
            viewModel.requestCompletion?()
        }
    }
}
