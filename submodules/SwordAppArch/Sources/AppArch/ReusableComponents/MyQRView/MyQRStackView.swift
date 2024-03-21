//
//  MyQRStackView.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 09.02.23.
//

import UIKit
import QrCode
import Combine
import Display
import MessageUI
import SwiftSignalKit

public final class MyQRStackView: SetupableStackView {
    // MARK: - IBOutlets

    @IBOutlet private weak var qrBackgroundView: UIView!
    @IBOutlet private weak var qrHolderImageView: UIImageView!
    @IBOutlet private weak var qrHolderView: UIView!
    @IBOutlet private weak var mainPageURLLabel: UILabel!
    
    @IBOutlet private weak var printButton: UIButton!
    @IBOutlet private weak var emailButton: UIButton!
    @IBOutlet private weak var shareButton: UIButton!
    
    @IBOutlet private weak var domainBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var qrBackgroundViewTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var qrBackgroundViewBottomConstraint: NSLayoutConstraint!

    // MARK: - Properties

    private var model: MyQRStackViewModel!
    private var cancellables: Set<AnyCancellable> = []
    private var shapeLayer: CAShapeLayer?
    private let qrNode = TransformImageNode()
    
    var disposble: Disposable?
    
    // MARK: - Setup UI
    
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        setupMainHolderView()
        
        emailButton.isHidden = !MFMailComposeViewController.canSendMail()
    }

    public func setup(with model: MyQRStackViewModel) {
        self.model = model
        
        mainPageURLLabel.text = "sword"
        setupButtonsCornerRadiuese()

        setupConstraints()
        setupImageNode()
    }

    private func setupImageNode() {
        qrNode.view.translatesAutoresizingMaskIntoConstraints = false
        
        qrHolderView.addSubview(qrNode.view)
        
        qrNode.view.addBorderConstraints(constraintSides: .all)
        
        bindToQRImageData()
    }

    private func setupConstraints() {
        domainBottomConstraint.constant = UIScreen.hasSmallScreen ? 20 : 50
        qrBackgroundViewBottomConstraint.constant = UIScreen.hasSmallScreen ? 20 : 50
        qrBackgroundViewTopConstraint.constant = UIScreen.hasSmallScreen ? 120 : 190
    }

    private func setupButtonsCornerRadiuese() {
        printButton.setCornerRadius(printButton.frame.height / 2)
        emailButton.setCornerRadius(emailButton.frame.height / 2)
        shareButton.setCornerRadius(shareButton.frame.height / 2)
    }

    // MARK: - Binding
    
    private func bindToQRImageData() {
        guard let userName = model.username ?? AppData.telegramUserUsername else { return }
        
        let codeLink = "\(Constants.AppURL.associatedDomain)\(userName)"
        
        disposble = (qrCode(string: codeLink, color: .black, backgroundColor: nil, icon: .custom(UIImage(imageName: "qr-app-icon")), ecl: "Q") |> map { $0.1 }).start { [ weak self ] completion in
            guard let self else { return }
            
            let image = completion(.init(corners: .init(radius: 10), imageSize: self.qrHolderImageView.frame.size, boundingSize: self.qrHolderImageView.frame.size, intrinsicInsets: .zero))?.generateImage()
            
            self.qrHolderImageView.image = image
            self.model.qrCodeImage.send(image?.jpegData(compressionQuality: 1))
        }
    }
    
    private func setupMainHolderView() {
        guard shapeLayer == nil else { return }

        let shadowLayer: CAShapeLayer = CAShapeLayer()
        
        qrBackgroundView.layer.cornerRadius = 10
        shadowLayer.path = UIBezierPath(roundedRect: qrBackgroundView.bounds,
           cornerRadius: 10).cgPath
        shadowLayer.fillColor = backgroundColor?.cgColor
        shadowLayer.shadowColor = UIColor.darkGray.cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = CGSize(width: 5,
                                          height: 5)
        shadowLayer.shadowOpacity = 0.1
        shadowLayer.shadowRadius = 10
        qrBackgroundView.layer.insertSublayer(shadowLayer, at: 0)
        
        setNeedsLayout()
        
        self.shapeLayer = shadowLayer
    }

    // MARK: - Actions
    
    @IBAction private func printButtonTouchUp(_ sender: UIButton) {
        model.actionPublisher.send(.print)
    }
    
    @IBAction private func emailButtonTouchUp(_ sender: UIButton) {
        model.actionPublisher.send(.sendViaEmail)
    }
    
    @IBAction private func shareButtonTouchUp(_ sender: UIButton) {
        model.actionPublisher.send(.share)
    }
}
