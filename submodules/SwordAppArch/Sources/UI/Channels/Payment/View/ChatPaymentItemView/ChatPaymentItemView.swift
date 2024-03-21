//
//  ChatPaymentItemView.swift
//  SwordAppArch
//
//  Created by Tigran Simonyan on 22.08.23.
//

import UIKit
import Combine
import Postbox
import Kingfisher
import AvatarNode
import TelegramCore
import SwiftSignalKit

private let avatarFont = avatarPlaceholderFont(size: 12.0)

public final class ChatPaymentItemView: SetupableView {
    // MARK: - IBOutlets
    
    @IBOutlet private weak var gradientedBackgroundView: UIView!
    @IBOutlet private weak var amountInfoHolderStackView: UIStackView!
    @IBOutlet private weak var paymentMethodTypeIconImageView: UIImageView!
    @IBOutlet private weak var amountLabel: UILabel!
    @IBOutlet private weak var messageLabel: UILabel!

    @IBOutlet private weak var actionsHolderView: UIView!
    @IBOutlet private weak var acceptButton: UIButton!
    @IBOutlet private weak var declineButton: UIButton!

    @IBOutlet private weak var statusHolderView: UIView!
    @IBOutlet private weak var statusTextLabel: UILabel!
    @IBOutlet private weak var mainHolderViewBottomConstraint: NSLayoutConstraint!

    @IBOutlet private weak var channelInfoHolderView: UIStackView!
    @IBOutlet private weak var channelImageNodeHolderView: UIView!
    @IBOutlet private weak var channelNameLabel: UILabel!

    private lazy var avatarNode: AvatarNode = AvatarNode(font: avatarFont)

    // MARK: - Properties

    private var model: ChatPaymentItemViewModel!
    private var cancellables: Set<AnyCancellable> = []

    public var frameHeight: CGFloat = 120
    
    // MARK: - Setup UI
    
    public func setup(with model: ChatPaymentItemViewModel) {
        self.model = model

        backgroundColor = .clear
              
        setupTextColors()
        setupStatusInfo()
        setupMessageLabel()
        setupPaymentStatus()
        setupGradientedViews()
//        setupSenderImageView()
        setupPaymentInformation()
        setupChannelInfoUIIfNeeded()
        
        actionsHolderView.isHidden = !model.canPerformActions
        setupButton(declineButton, title: Constants.Localization.Common.decline, color: theme.colors.mainRed)
        setupButton(acceptButton, title: Constants.Localization.Common.accept, color: theme.colors.textBlue)
        
        mainHolderViewBottomConstraint.constant = model.canPerformActions ? 30 : 25
        bindToCryptoIcon()
        bindToCryptoIconDownloadPublisher()

        model.prefetchImages()
    }
    
    private func setupPaymentInformation() {
        amountLabel.text = model.requestAmount

//        if let paymentTransaction = model.paymentInfo.value?.paymentTransaction,
//            model.paymentInfo.value?.type == .request {
//            setupRequestPaymentInfo(paymentTransaction: paymentTransaction)
//        } else {
//            amountLabel.text = model.requestAmount
//            requestTextLabel.text = model.requestText
//            amountInfoHolderStackView.isHidden = false
//        }
    }
    
    private func setupGradientedViews() {
//        gradientedBackgroundView.setCornerRadius(8)
//        setupGradientedView(gradientedBackgroundView,
//                            colors: model.gradientColors.map { $0.cgColor },
//                            hasBorders: false)
    }

    private func setupGradientedView(_ view: GradientedBorderedView,
                                     colors: [CGColor],
                                     hasBorders: Bool) {
        view.axis = .diagonal
        view.hasBorders = hasBorders
        view.colors = colors
    }

    private func setupMessageLabel() {
        guard let note = model.note else {
            messageLabel.isHidden = true
            
            return
        }
        
        messageLabel.isHidden = false
        messageLabel.text = note.trimmingCharacters(in: .whitespacesAndNewlines)
        
        frameHeight += note.height(withConstrainedWidth: Constants.paymentItemWidth, font: messageLabel.font)
    }

    private func setupButton(_ button: UIButton, title: String, color: UIColor) {
        button.setCornerRadius(2)
        button.setTitle(title, for: .normal)
        button.layer.borderWidth = 2
        button.layer.borderColor = color.cgColor
    }
    
    private func setupTextColors() {
        let isMine = model.isMine
        let color = isMine ? theme.colors.mainWhite : theme.colors.textColor
        
        statusTextLabel.textColor = color
        amountLabel.textColor = color
        channelNameLabel.textColor = color
        messageLabel.textColor = color
    }

    private func setupRequestPaymentInfo(paymentTransaction: ChannelMessageModel.PaymentTransaction) {
//        guard let paymentInfo = model.paymentInfo.value,
//              let user = model.paymentInfo.value?.creator else { return }
//
//        amountInfoHolderStackView.isHidden = paymentTransaction.status != .completed
//
//        let senderUser: PaymentUserModel = {
//            guard let transaction = paymentInfo.paymentTransaction else { return paymentInfo.creator }
//
//            return transaction.user
//        }()
//
//        let sender: String = prepareName(for: senderUser)
//
//        if paymentTransaction.status == .completed {
//            let reciever: String = prepareName(for: user)
//
//            if let amount = paymentTransaction.amount,
//                let currency = paymentTransaction.currency {
//                let formatedCurrency = currency == "EUR" ? Constants.euro : currency
//                amountLabel.text = "\(formatedCurrency) \(amount.bringToPresentableFormat())"
//            } else {
//                amountInfoHolderStackView.isHidden = true
//            }
//
//            model.paymentStatus.send(.received)
//            requestTextLabel.text = Constants.Localization.Channels.receivedFrom(reciever: reciever, sender: sender)
//        } else {
//            let reciever: String =  prepareName(for: user, isRejecting: true)
//            model.paymentStatus.send(.rejected)
//            requestTextLabel.text = Constants.Localization.Channels.rejectedRequest(who: sender, whose: reciever)
//        }
//
//        frameHeight += (requestTextLabel.text ?? "").height(withConstrainedWidth: Constants.paymentItemWidth,
//                                                            font: requestTextLabel.font)
    }

    private func setupStatusInfo() {
        statusHolderView.setCornerRadius(statusHolderView.frame.height / 2)

        guard model.decodedMessage.paymentType != .reject else {
            setupRejectedStatus()
            
            return
        }
        
        lazy var statusViewBackgroundColor: UIColor = {
            return model.decodedMessage.paymentType == .request ? UIColor(rgb: 0xD6C8DA) : theme.colors.textBlue.withAlphaComponent(0.1)
        }()

        statusHolderView.backgroundColor = model.isMine ? theme.colors.darkBlue : statusViewBackgroundColor
    }

    private func setupRejectedStatus() {
        statusHolderView.backgroundColor = theme.colors.mainRed.withAlphaComponent(0.1)
    }

    private func prepareName(for user: PaymentUserModel, isRejecting: Bool = false) -> String {
        let currentUserName = isRejecting ? Constants.Localization.Common.your : Constants.Localization.Common.you

        return user.username == AppData.currentUserInfo?.username ? currentUserName : user.fullName
    }
    
    private func setupChannelInfoUIIfNeeded() {
        guard let peerIdValue = model.decodedMessage.peerId,
              let extraPeerIdValue = model.decodedMessage.extraPeerId else {
            channelInfoHolderView.isHidden = true
            
            return
        }
        
        let peerId = PeerId(Int64(peerIdValue))
        let extraPeerId = PeerId(Int64(extraPeerIdValue))

        channelInfoHolderView.isHidden = false
        setupChannelInfo(peerId: peerId, extraPeerId: extraPeerId)
        
    }
    func setupChannelInfo(peerId: PeerId, extraPeerId: PeerId) {
        let _ = combineLatest(
            queue: Queue.mainQueue(),
            self.model.context.engine.data.get(TelegramEngine.EngineData.Item.Peer.Peer(id: peerId)),
            self.model.context.engine.data.get(TelegramEngine.EngineData.Item.Peer.Peer(id: extraPeerId))
        ).start(next: { [ weak self ] peer, extraPeer in
            let correctPeer = peer ?? extraPeer
            guard let correctPeer else {
                self?.channelInfoHolderView.isHidden = true
                return
            }
            
            self?.channelInfoHolderView.isHidden = false

            let name = correctPeer.indexName.stringRepresentation(lastNameFirst: false)
            self?.channelNameLabel.text = name
            self?.setupImageNode(with: correctPeer)
        })
    }

    private func setupImageNode(with peer: EnginePeer) {
        avatarNode.view.translatesAutoresizingMaskIntoConstraints = false
        
        channelImageNodeHolderView.addSubview(avatarNode.view)
        
        avatarNode.view.addBorderConstraints(constraintSides: .all)
        avatarNode.setPeer(context: model.context,
                           account: model.context.account,
                           theme: model.theme,
                           peer: peer,
                           displayDimensions: .init(width: 30,
                                                    height:30))
        
        avatarNode.updateSize(size: .init(width: 30,
                                          height:30))
    }

    // MARK: - Binding
    
    private func bindToCryptoIcon() {
        model.cryptoIconDataPublisher
            .receive(on: RunLoop.main)
            .sink { [ weak self ] data in
                guard let data,
                      let iconImage = UIImage(data: data) else {
                    self?.paymentMethodTypeIconImageView.isHidden = true
                    
                    return
                    
                }

                self?.paymentMethodTypeIconImageView.isHidden = false
                self?.paymentMethodTypeIconImageView.image = iconImage
            }
            .store(in: &cancellables)
    }
        
    private func setupPaymentStatus() {
        let text: NSAttributedString

        switch model.decodedMessage.paymentType {
        case .send, .accept:
            let status = model.isMine ? Constants.Localization.Common.sent : "You received"
            text = self.model.attributedStatus(isRejected: false, text: status)
        case .request:
            let status = model.isMine ? "You requested" : Constants.Localization.Common.requested
            text = self.model.attributedStatus(isRejected: false, text: status)
        case .reject:
            text = self.model.attributedStatus(isRejected: true, text: Constants.Localization.Common.rejected)
        }
        
        self.statusTextLabel.attributedText = text
    }
    
    private func bindToCryptoIconDownloadPublisher() {
        model.cryptoIconDownloadPublisher.sink { [ weak self ] in
            guard let self,
                  let paymnetCurrencyIconURL = self.model.paymnetCurrencyIconURL else {
                self?.paymentMethodTypeIconImageView.isHidden = true
                
                return
            }

            let processor = ResizingImageProcessor(referenceSize: CGSize(width: 40, height: 40))

            KingfisherManager.shared.retrieveImage(with: paymnetCurrencyIconURL, options: [.processor(processor),
                                                                                           .fromMemoryCacheOrRefresh]) { [ weak self ] result in
                switch result {
                case .success(let value):
                    if let data = value.data() {
                        self?.paymentMethodTypeIconImageView.image = UIImage(data: data)
                        self?.paymentMethodTypeIconImageView.isHidden = false
                    } else {
                        self?.paymentMethodTypeIconImageView.isHidden = true
                    }
                case .failure(let error):
                    self?.paymentMethodTypeIconImageView.isHidden = true
                    self?.paymentMethodTypeIconImageView.image = nil
                    print("Sender avatar fetching failed: \(error)")
                }
            }
        }
        .store(in: &cancellables)
    }
    
    // TODO: - create enum
    @IBAction private func detailsButtonTouchUp(_ sender: UIButton) {
        model.detailsButtonPublisher.send(())
    }
    
    @IBAction private func declineButtonTouchUp(_ sender: UIButton) {
        model.postNotification(name: .declinePayment)
    }

    @IBAction private func acceptButtonTouchUp(_ sender: UIButton) {
        model.postNotification(name: .acceptPayment)
    }
}
