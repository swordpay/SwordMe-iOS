//
//  TopUpViewController.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 25.05.23.
//

import UIKit
import Display

final class TopUpViewController: GenericStackViewController<TopUpViewModel, TopUpStackView> {
    // MARK: = Properties
    
    override var shouldRespectSafeArea: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Lifecycle Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
    }

    // MARK: - Binding
    
    override func bindViewModel() {
        super.bindViewModel()
        
        bindToCloseAction()
        bindToTopUpAction()
    }

    private func bindToCloseAction() {
        viewModel.setupModel.value?.closeButtonTapHandler
            .sink { [ weak self ] in
                self?.dismiss(animated: true)
            }
            .store(in: &cancellables)
    }
    
    private func bindToTopUpAction() {
        viewModel.setupModel.value?.topUpButtonTapHandler
            .sink { [ weak self ] in
                self?.navigateToTopUpTap()
            }
            .store(in: &cancellables)
    }

    // MARK: - Navigation
    
    private func navigateToTopUpTap() {
        
        let tabIndex = viewModel.paymentMethodType == .fiat ? 1 : 2
        let userInfo = ["selectedTabIndex": tabIndex]
        
//        tabBarController?.tabBar.isHidden = false
        navigator.goTo(BackDestination.dismiss(animated: true, completion: { [ weak self ] in
            NotificationCenter.default.post(name: .topUpDidPressed, object: self, userInfo: userInfo)
        }))
//                       (animated: true, completion: {
//            if let controller = UIApplication.shared.topMostViewController() as? ChatViewController {
//                controller.dimsissScreen()
//
//            }
//
//            if let tabBarController = UIApplication.shared.rootViewController() as? TabBarController {
//                tabBarController.selectedIndex = tabIndex
//            }
//        }))
    }
}
