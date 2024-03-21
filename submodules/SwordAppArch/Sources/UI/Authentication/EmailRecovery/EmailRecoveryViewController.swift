//
//  EmailRecoveryViewController.swift
//  SwordAppArch
//
//  Created by Tigran Simonyan on 11.08.23.
//

import UIKit
import SwiftSignalKit

public final class EmailRecoveryViewController: GenericStackViewController<EmailRecoveryViewModel, EmailRecoveryStackView> {
    
    public override var shouldEmbedInScrollView: Bool { return true }
    
    override var footerContainerViewInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 20, bottom: -30, right: -20)
    }

    public let actionDisposable = MetaDisposable()

    // MARK: - Lifecycle Methods
    
    public override func displayNodeDidLoad() {
        super.displayNodeDidLoad()
        
        setupFooterView()
    }
    
    deinit {
        actionDisposable.dispose()
    }

    private func setupFooterView() {
        let nextButton = GradientedButton()
        
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.setup(with: viewModel.nextButtonViewModel)
        
        NSLayoutConstraint.activate([
            nextButton.heightAnchor.constraint(equalToConstant: Constants.defaultButtonHeight)
        ])

        self.footerView = nextButton
    }

}
