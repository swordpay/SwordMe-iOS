//
//  TFAPasswordViewController.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 11.08.23.
//

import UIKit
import Display
import TelegramPresentationData

public final class TFAPasswordViewController: GenericStackViewController<TFAPasswordViewModel, TFAPasswordStackView> {
    
    public override var shouldEmbedInScrollView: Bool { return true }
    public var presentationData: PresentationData?

    override var footerContainerViewInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 20, bottom: -30, right: -20)
    }
    
    // MARK: - Lifecycle Methods
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
    }

    public override func displayNodeDidLoad() {
        super.displayNodeDidLoad()
        
        setupFooterView()
    }
    
    // MARK: - Setup UI

    private func setupNavigationBar() {
        navigationBar?.backPressed = { [ weak self ] in
            self?.viewModel.back?()
        }
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
    
    public func passwordIsInvalid() {
        if self.isNodeLoaded {
            self.stackView.resetPassord()
        }
    }
    
    // MARK: - Navigation
    
    private func showBackAlert() {
        guard let presentationData else { return }

        let text = presentationData.strings.Login_CancelPhoneVerification
        let proceed = presentationData.strings.Login_CancelPhoneVerificationContinue
        let stop = presentationData.strings.Login_CancelPhoneVerificationStop

        present(standardTextAlertController(theme: AlertControllerTheme(presentationData: presentationData), title: nil, text: text, actions: [TextAlertAction(type: .genericAction, title: proceed, action: {
        }), TextAlertAction(type: .defaultAction, title: stop, action: { [ weak self ] in
            self?.viewModel.back?()
        })]), in: .window(.root))
    }

}
