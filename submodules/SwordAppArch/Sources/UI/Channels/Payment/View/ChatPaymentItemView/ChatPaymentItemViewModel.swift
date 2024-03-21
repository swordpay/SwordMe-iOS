//
//  ChatPaymentItemViewModel.swift
//  SwordAppArch
//
//  Created by Tigran Simonyan on 22.08.23.
//

import UIKit
import Combine
import Postbox
import Kingfisher
import AccountContext
import TelegramPresentationData

public protocol ChatMessageTransactionContentViewModelling {
    var frameHeight: CGFloat { get set }
}

public final class ChatPaymentItemViewModel: ChatMessageTransactionContentViewModelling {
    private var cancellables: Set<AnyCancellable> = []

    public let decodedMessage: DecodedPaymentMessage

    let detailsButtonPublisher: PassthroughSubject<Void, Never> = PassthroughSubject()
    let declineButtonPublisher: PassthroughSubject<Void, Never> = PassthroughSubject()
    let acceptButtonPublisher: PassthroughSubject<Void, Never> = PassthroughSubject()
    let cryptoIconDataPublisher: PassthroughSubject<Data?, Never> = PassthroughSubject()
    let cryptoIconDownloadPublisher: PassthroughSubject<Void, Never> = PassthroughSubject()

    
    var context: AccountContext
    var theme: PresentationTheme
    var messageId: Int32
    var isMine: Bool
    var author: Peer
    var requestAmount: String? {
        var amount: String {
            return Double(decodedMessage.amount)?.bringToPresentableFormat(maximumFractionDigits: 8) ?? decodedMessage.amount
        }

        let currency = decodedMessage.currency == "EUR" ? Constants.euro : decodedMessage.currency
        return "\(currency) \(amount)"
    }
    
    var canPerformActions: Bool {
        guard decodedMessage.paymentType == .request else { return false }
        
        return !isMine && !AppData.isChannelAdmin
    }
    
    var gradientColors: [UIColor] {
        return [.clear]
//        let currentTheme = ThemeProvider.currentTheme
//        if isMine {
//            return [ currentTheme.colors.card1StartGradient,
//                     currentTheme.colors.card1EndGradient ]
//        } else {
//            return [ currentTheme.colors.messageBackgroundGray,
//                     currentTheme.colors.messageBackgroundGray]
//        }
    }
    lazy var userFullName: String = {
        switch author.indexName {
        case.title(let title, _):
            return title
        case .personName(let first, let last, _, _):
            return first + " " + last
        }
    }()

    lazy var sender = isMine ? Constants.Localization.Common.you : userFullName

    var requestText: String? {
        if decodedMessage.paymentType == .request {
            paymentStatus.send(ChatPaymentItemViewModel.PaymentStatus.reqeusted)
            return Constants.Localization.Channels.sentARequest(sender: sender)
        } else {
            paymentStatus.send(ChatPaymentItemViewModel.PaymentStatus.sent)
            return Constants.Localization.Channels.paymentFrom(sender: sender)
        }
    }
    
    var note: String? {
        return decodedMessage.note
    }
    
    var paymnetCurrencyIconURL: URL? {
        guard decodedMessage.currency != "EUR",
              let url = Constants.AppURL.cryptoIconURL(coin: decodedMessage.currency) else { return nil }
        
        return url
    }
    
    var statusText: String {
        switch decodedMessage.paymentType {
        case .request:
            return Constants.Localization.Common.requested
        case .send:
            return Constants.Localization.Common.sent
        case .accept:
            return  Constants.Localization.Common.accept
        case .reject:
            return  Constants.Localization.Common.rejected
        }
    }
    
    var paymentStatus: PassthroughSubject<ChatPaymentItemViewModel.PaymentStatus, Never> = PassthroughSubject()

    public var frameHeight: CGFloat
    public init(decodedMessage: DecodedPaymentMessage, isMine: Bool, author: Peer, messageId: Int32, context: AccountContext, theme: PresentationTheme) {
        self.author = author
        self.decodedMessage = decodedMessage
        self.isMine = isMine
        self.messageId = messageId
        self.context = context
        self.theme = theme
        
        self.frameHeight = 115
        prepareHeight()
    }
    
    private func prepareHeight() {
        self.frameHeight = canPerformActions ? 150 : 100

        if decodedMessage.peerId != nil && decodedMessage.extraPeerId != nil {
            frameHeight += 40
        }
        
        if let note {
            frameHeight += (note.trimmingCharacters(in: .whitespacesAndNewlines).height(withConstrainedWidth: Constants.paymentItemWidth - 18, font: ThemeProvider.currentTheme.fonts.regular(ofSize: 16, family: .poppins)) + 10)
        }
    }

    public func providePaymentText() -> String {
        let text: String
        switch decodedMessage.paymentType {
        case .request:
            text = "\(sender) make a request"
        case .send:
            text = "sent by \(sender)"
        case .accept:
            text = "\(sender) accepted request"
        case .reject:
            text = "\(sender) rejected request"
        }

        return text
    }

    func prepareCryptoImageData() {
        guard let paymnetCurrencyIconURL else {
            cryptoIconDataPublisher.send(nil)
            
            return
        }

        let processor = ResizingImageProcessor(referenceSize: CGSize(width: 40, height: 40))

        KingfisherManager.shared.retrieveImage(with: paymnetCurrencyIconURL, options: [.processor(processor),
                                                                                       .fromMemoryCacheOrRefresh]) { [ weak self ] result in
            switch result {
            case .success(let value):
                self?.cryptoIconDataPublisher.send(value.data())
            case .failure(let error):
                self?.cryptoIconDataPublisher.send(nil)
                print("Sender avatar fetching failed: \(error)")
            }
        }
    }
    
    func attributedStatus(isRejected: Bool, text: String) -> NSAttributedString {
        let fonts = ThemeProvider.currentTheme.fonts
        
        guard !isRejected else {
            return NSAttributedString(string: "❌  \(text)",
                                      attributes: [.font: fonts.regular(ofSize: 11, family: .poppins)])
        }
        
        let prefix = NSMutableAttributedString(string: "💰  ",
                                               attributes: [.font: fonts.regular(ofSize: 14, family: .poppins)])
        let mainText = NSAttributedString(string: text,
                                          attributes: [.font: fonts.regular(ofSize: 11, family: .poppins)])
        
        prefix.append(mainText)
        
        return prefix
    }

    public func prefetchImages() {
        cryptoIconDownloadPublisher.send(())
    }

    private func prepareName(for user: PaymentUserModel, isRejecting: Bool = false) -> String {
        let currentUserName = isRejecting ? Constants.Localization.Common.your : Constants.Localization.Common.you

        return user.username == AppData.currentUserInfo?.username ? currentUserName : (user.firstName + " " + user.lastName)
    }
    
    // MARK: - Actions Handling
    
    func postNotification(name: Notification.Name) {
        guard let paymentId = getPaymentId() else { return }
        
        let userInfo: [String : Any] = [ "paymentId": paymentId,
                                         "peerId": author.id,
                                         "messageId": messageId,
                                         "decodedMessage": decodedMessage ]
        
        NotificationCenter.default.post(name: name, object: self, userInfo: userInfo)
    }
}

extension ChatPaymentItemViewModel {
    private func getPaymentId() -> String? {
        guard let url = URL(string: decodedMessage.url),
              let components = NSURLComponents(url: url, resolvingAgainstBaseURL: true),
              let paymentId = components.queryItems?.first(where: {$0.name == "id"})?.value as? String else {
            
            return nil
        }
     
        return paymentId
    }
    
}

public extension ChatPaymentItemViewModel {
    enum PaymentStatus {
        case sent
        case received
        case reqeusted
        case rejected
    }
}

