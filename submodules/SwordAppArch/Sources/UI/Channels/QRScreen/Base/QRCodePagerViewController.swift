//
//  QRCodePagerViewController.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 09.02.23.
//

import UIKit
import MessageUI

final class QRCodePagerViewController: GenericStackViewController<QRCodePagerViewModel, QRCodePagerStackView>, PrintInteractable, EmailSendable {
    // MARK: - Properties
    
    override var shouldRespectSafeArea: Bool { return false }

    override func updateStackView(with model: QRCodePagerStackViewModel) {
        super.updateStackView(with: model)
        
        updateMyQRScreenActionHandler()
    }

    // MARK: - Binding
    
    override func bindViewModel() {
        super.bindViewModel()
        
        bindToCloseButtonPublisher()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    private func updateMyQRScreenActionHandler() {
        guard let controller = stackView.qrOptionsViewControllers.last as? MyQRCodeViewController else { return }
        controller.actionHandler = { [ weak self ] action in
                guard let self,
                      let imageData = controller.viewModel.setupModel.value?.qrCodeImage.value,
                      let image = UIImage(data: imageData) else { return }

                switch action {
                case .print:
                    self.print(image: image)
                case .share:
                    let items = [image]
                    let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)

                    self.navigationController?.present(ac, animated: true)
                case .sendViaEmail:
                    self.sendEmail(to: nil,
                                   subject: Constants.Localization.Profile.emailSubject,
                                   body: Constants.Localization.Profile.emailBody,
                                   attachment: imageData)
                }
        }

    }
    
    private func bindToCloseButtonPublisher() {
        viewModel.setupModel.value?.closeButtonPublisher
            .sink { [ weak self ] in
                self?.dismissNotFromRoot(animated: true)
            }
            .store(in: &cancellables)
    }
    
}

extension QRCodePagerViewController: UIPrintInteractionControllerDelegate {
    
}


extension QRCodePagerViewController: MFMailComposeViewControllerDelegate {
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
