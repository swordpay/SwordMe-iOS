//
//  MyQRCodeViewController.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 09.02.23.
//

import UIKit
import MessageUI

public final class MyQRCodeViewController: GenericStackViewController<MyQRCodeViewModel, MyQRStackView>, PrintInteractable, EmailSendable {
    // MARK: - Properties
    
    public override var shouldEmbedInScrollView: Bool { return false }
    override var shouldRespectSafeArea: Bool { return false }

    lazy var actionHandler: (MyQRStackViewModel.Action) -> Void = { [ weak self ] action in
            guard let self,
                  let imageData = self.viewModel.setupModel.value?.qrCodeImage.value,
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

    // MARK: - Lifecycle Methods
    
    public override func viewDidLoad() {
        super.viewDidLoad()
                
        
        setupLeftBarButton()
    }
    
    private func setupLeftBarButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelBarButtonHandler))
    }
    
    @objc
    private func cancelBarButtonHandler() {
        self.dismissNotFromRoot(animated: true)
    }
    
    // MARK: - Binding
    
    public override func bindViewModel() {
        super.bindViewModel()
        
        bindToQRActionPublisher()
    }
    
    private func bindToQRActionPublisher() {
        viewModel.setupModel.value?.actionPublisher
            .sink { [ weak self ] action in
                self?.actionHandler(action)
            }
            .store(in: &cancellables)
    }
}

extension MyQRCodeViewController: UIPrintInteractionControllerDelegate {
    
}


extension MyQRCodeViewController: MFMailComposeViewControllerDelegate {
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
