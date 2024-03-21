//
//  BuyOrSellCryptoViewController.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 09.03.23.
//

import UIKit
import Display
import SafariServices
import AsyncDisplayKit

final class BuyOrSellCryptoViewController: GenericStackViewController<BuyOrSellCryptoViewModel, BuyOrSellCryptoStackView>, InAppWebsitePresentable {

    // MARK: - Properties

    override var shouldEmbedInScrollView: Bool {
        return true
    }
    
    override var footerContainerViewInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: -10, right: -20)
    }

    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = viewModel.cryptoModel.name

        setupFooterView()
        viewModel.fetchTradeInfoData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.startTimer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        viewModel.stopTimer()
    }

    // MARK: - Setup UI

    private func setupFooterView() {
        let buyOrSellButton = GradientedButton()
        
        buyOrSellButton.translatesAutoresizingMaskIntoConstraints = false
        buyOrSellButton.setup(with: viewModel.buyOrSellButtonViewModel)
        
        NSLayoutConstraint.activate([
            buyOrSellButton.heightAnchor.constraint(equalToConstant: Constants.defaultButtonHeight)
        ])

        self.footerView = buyOrSellButton
    }
    
    // MARK: - Binding
    
    override func bindViewModel() {
        super.bindViewModel()
        
        bindToRedirectUrl()
        bindToContextMenuPublisher()
        bindToBuyCryptoCompletionPublisher()
        bindToSellCryptoCompletionPublisher()
    }
    
    private func bindToRedirectUrl() {
        viewModel.redirectUrlPublisher
            .sink { [ weak self ] redirectUrl in
                self?.openWebsite(path: redirectUrl)
            }
            .store(in: &cancellables)
    }
    
    private func bindToSellCryptoCompletionPublisher() {
        viewModel.sellCryptoCompletionPubliser
            .sink { [ weak self ] isSuccess in
                self?.showSellCompletionAlert(isSuccess: isSuccess)
            }
            .store(in: &cancellables)

    }

    private func bindToBuyCryptoCompletionPublisher() {
        viewModel.buyCryptoCompletionPubliser
            .sink { [ weak self ] isSuccess in
                self?.showCompletionAlert(message: "Your transaction has been completed successfully", isSuccess: true)
            }
            .store(in: &cancellables)
    }

    private func bindToContextMenuPublisher() {
        viewModel.setupModel.value?.contextMenuPublisher
            .sink { [ weak self ] (viewController, node, rect) in
                guard let self else { return }
                self.present(viewController, in: .window(.root),
                             with: ContextMenuControllerPresentationArguments(sourceNodeAndRect: { [ weak self ] in
                    guard let self else { return nil }
                    
                    let selfNode = self.stackView.asyncdisplaykit_node ?? .init()
                    return (node, rect.insetBy(dx: 0.0, dy: -2.0), selfNode, self.stackView.bounds)}))
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Navigation
    
    private func showSellCompletionAlert(isSuccess: Bool) {
        let message = viewModel.provideMessageForSellingCompeltion(isSuccess: isSuccess)

        showCompletionAlert(message: message, isSuccess: isSuccess)
    }

    private func showCompletionAlert(message: String, isSuccess: Bool) {
        let alertModel = AlertModel(message: message, preferredStyle: .alert, actions: [.ok], animated: true)
        let alertDestination = AlertDestination.alert(model: alertModel, presentationCompletion: nil) { [ weak self ] _ in
            if isSuccess {
                NotificationCenter.default.post(name: .cryptoAccountInfoDidChange, object: nil)
                if let navController = self?.navigationController as? NavigationController {
                    navController.popToRoot(animated: true)
                }
            }
        }
        
        navigator.goTo(alertDestination)
    }
}

extension BuyOrSellCryptoViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        NotificationCenter.default.post(name: .cryptoAccountInfoDidChange, object: self)
    }
}
