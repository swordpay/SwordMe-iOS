//
//  ChannelPaymentViewController.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 26.12.22.
//

import UIKit
import Combine
import Display
import TelegramCore
import SafariServices
import AccountContext
import SwiftSignalKit
import TelegramPresentationData

public final class ChannelPaymentViewController: GenericStackViewController<ChannelPaymentViewModel, ChannelPaymentStackView>, InAppWebsitePresentable {

    // MARK: - Properties
    private var presentationDataDisposable: Disposable?
    private var transactionDispossable: Disposable?
    private var topUpCancelable: AnyCancellable?
    
    var context: AccountContext

    public override var shouldEmbedInScrollView: Bool { return true }
    override var needToOverrideKeyboardChangesHandler: Bool { return false }

    override func emptyStateViewProvider() -> UIView? {
        guard viewModel.emptyStateReason != nil ,
              let view = ChannelPaymentEmptyStateView.loadFromNib() else { return nil }
        
        view.setup(with: viewModel.emptyStateViewModel)
        
        return view
    }

    public init(viewModel: ChannelPaymentViewModel, context: AccountContext) {
        self.context = context

        let navPresentationData: NavigationBarPresentationData = .init(theme: .init(buttonColor: ThemeProvider.currentTheme.colors.gradientDarkBlue,
                                                                                    disabledButtonColor: ThemeProvider.currentTheme.colors.textColor,
                                                                                    primaryTextColor: ThemeProvider.currentTheme.colors.textColor,
                                                                                    backgroundColor: ThemeProvider.currentTheme.colors.mainWhite,
                                                                                    enableBackgroundBlur: false,
                                                                                    separatorColor: UIColor(rgb: 0xA6A6AA),
                                                                                    badgeBackgroundColor: ThemeProvider.currentTheme.colors.mainRed,
                                                                                    badgeStrokeColor: ThemeProvider.currentTheme.colors.mainWhite,
                                                                                    badgeTextColor: ThemeProvider.currentTheme.colors.mainWhite),
                                                                       strings: .init(presentationStrings: .init()))
        super.init(viewModel: viewModel,
                   navigationBarPresentationData: navPresentationData)
        
        self.tabBarItemContextActionType = .always

        self.statusBar.statusBarStyle = .Black

        self.tabBarItem.title = "Account"
        
        let icon = UIImage(imageName: Constants.AssetName.TabBar.fiatAccount)

        self.tabBarItem.image = icon
        self.tabBarItem.selectedImage = icon
        
//        self.presentationDataDisposable = (context.sharedContext.presentationData
//        |> deliverOnMainQueue).start(next: { [weak self] presentationData in
//            if let strongSelf = self {
//                let previousTheme = strongSelf.presentationData.theme
//                let previousStrings = strongSelf.presentationData.strings
//
//                strongSelf.presentationData = presentationData
//
//                if previousTheme !== presentationData.theme || previousStrings !== presentationData.strings {
//                    strongSelf.updateThemeAndStrings()
//                }
//            }
//        })
    }
    
    private func setupNavigationTitle() {
        title = "Send or Request"
    }

    private func performTransaction(isRequesting: Bool, amount: Double? = nil) {
        guard !self.viewModel.membersInfoHolderViewModel.participants.value.isEmpty else { return }

        let paymentAmount = amount ?? viewModel.paymentAmount
              
        transactionDispossable = context.account.postbox.transaction({ [ weak self ] transaction in
            guard let self else { return }
            let participants = self.viewModel.membersInfoHolderViewModel.participants.value
            
            let swordPeers = participants
                .compactMap { info in
                    if let peer = transaction.getPeer(info.enginePeer.id),
                       let inputPeer = apiInputPeer(peer) {
                        let accessHash: String? = {
                            
                            if case let .channel(telegramChannel) = info.enginePeer {
                                if let hash = telegramChannel.accessHash?.value {
                                    return "\(UInt64(bitPattern: hash))"
                                } else {
                                    return nil
                                }
                            }

                            guard case let .user(telegramUser) = info.enginePeer else {
                                let result = inputPeer.descriptionFields().1.filter( {( key, _) in
                                    return key == "accessHash"
                                }).first?.1 as? Int64
                                
                                return result != nil ? "\(UInt64(bitPattern: result!))" : nil
                            }
                            
                            if let hash = telegramUser.accessHash?.value {
                                return "\(UInt64(bitPattern: hash))"
                            } else {
                                return nil
                            }
                        }()
                        
                        let title: String? = {
                            switch peer.indexName {
                            case let .title(title, _):
                                return title
                            case let .personName(first, last, _, _) :
                                return "\(first) \(last)"
                            }
                        }()
                        
                        var participantsAmount: Double {
                            guard isRequesting else { return (paymentAmount ?? 0) / Double(participants.count) }
                            
                            return paymentAmount ?? 0
                        }

                        return SwordPeer(peerId: Int(info.enginePeer.id.id._internalGetInt64Value()),
                                         extraPeerId: Int(info.enginePeer.id.toInt64()),
                                         accessHash: accessHash,
                                         title: title,
                                         inputPeerEmpty: inputPeer,
                                         amount: participantsAmount)
                        
                    }
                    
                    return nil
                }
            DispatchQueue.main.async {   
                self.viewModel.performTransaction(peers: swordPeers, isRequesting: isRequesting)
            }
        })
        .start()
    }

    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        presentationDataDisposable?.dispose()
        transactionDispossable?.dispose()
    }

    // MARK: - Lifecycle methods
        
    public override func viewDidLoad() {
        super.viewDidLoad()
                
        title = viewModel.stateInfo.isRequesting ? "Send or Request" : "Accept Request"
    }
    
    public override func displayNodeDidLoad() {
        super.displayNodeDidLoad()
        
        if let peerId = viewModel.stateInfo.peerId {
            let _ = self.context.engine.data.get(TelegramEngine.EngineData.Item.Peer.Peer(id: peerId))
                .start(next: { [ weak self ] peer in
                    guard let peer = peer, let self else {
                        return
                    }
                    
                    self.viewModel.membersInfoHolderViewModel.participants.send([.init(enginePeer: peer,
                                                                             account: context.account,
                                                                             context: context,
                                                                             theme: context.sharedContext.currentPresentationData.with { $0 }.theme,
                                                                             synchronousLoads: true,
                                                                             peerPresenceState: ChannelsHeaderViewModel.PeerPresenceState.online)])
                })
        }

        setupFooterView()
        viewModel.fetchAccountBalance()
    }
    
    private func setupFooterView() {
        guard let view = ChannelPaymentFooterView.loadFromNib() else { return }
        
        view.setup(with: viewModel.footerSetupModel)
        
        self.footerView = view
    }

    override func handleEmptyState(_ isEmptyState: Bool) {
        setupEmptyStateView()
        
        super.handleEmptyState(isEmptyState)
    }

    //MARK: - Binging

    public override func bindViewModel() {
        super.bindViewModel()
    
        bindToSeeAllUsers()
        bindToPaymentCompletion()
        bindToAddNewParticipents()
        bindToRedirectURLPublisher()
        bindToCryptoPickerPublisher()
        bindToTransactionButtonHandler()
        bindToAmountTypePickerPublishers()
        bindToMinimumAmountErrorPublisher()
        bindToCryptoAccountUpdatePublisher()
        bindToValidationAlertErrorMessagePublisher()
    }

    private func bindToCryptoAccountUpdatePublisher() {
        viewModel.cryptoAccountUpdatePublisher
            .sink { [ weak self ] reason in
                self?.handleUnAvailableCryptoReason(reason)
            }
            .store(in: &cancellables)
    }

    private func bindToTransactionButtonHandler() {
        viewModel.transactionButtonHandler
            .sink { [ weak self ] isRequesting in
                self?.view.endEditing(true)
                self?.performTransaction(isRequesting: isRequesting)
            }
            .store(in: &cancellables)
    }
        
    private func bindToSeeAllUsers() {
        viewModel.channelParticipantsPresenterPublisher
            .sink { [ weak self ] in
                self?.goToChannelParticipantsScreen()
            }
            .store(in: &cancellables)
    }
    
    private func bindToAddNewParticipents() {
        viewModel.addNewParticipantsPublisher
            .sink { [ weak self ] in
                self?.goToParticipantsPicker()
            }
            .store(in: &cancellables)
    }

    private func bindToPaymentCompletion() {
        viewModel.paymentCompletion
            .sink { [ weak self ] in
                self?.goToChat()
            }
            .store(in: &cancellables)
    }
    
    private func bindToRedirectURLPublisher() {
        viewModel.redirectURLPublisher
            .sink { [ weak self ] redirectUrl in
                self?.dismiss(animated: false) {
                    self?.openWebsite(path: redirectUrl)
                }
            }.store(in: &cancellables)
    }
    
    private func bindToCryptoPickerPublisher() {
        viewModel.cryptoPickerPublisher
            .sink { [ weak self ] in
                self?.goToCryptoPicker()
            }
            .store(in: &cancellables)
    }
    
    private func bindToAmountTypePickerPublishers() {
        viewModel.amountTypePickerPublishers
            .sink { [ weak self ] in
                self?.showAmountTypeAlert()
            }
            .store(in: &cancellables)
    }
    
    private func bindToValidationAlertErrorMessagePublisher() {
        viewModel.validationAlertErrorMessagePublisher
            .sink { [ weak self ] errorMessage in
                self?.showPayingValidationErrorAlert(with: errorMessage)
            }
            .store(in: &cancellables)
    }
    
    private func bindToMinimumAmountErrorPublisher() {
        viewModel.minimumAmountErrorPublisher
            .sink { [ weak self ] amount in
                self?.showPayingMinimumAmountValidationError(amount: amount)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Navigator
    
    private func showAmountTypeAlert() {
        let alertModel = AlertModel(title: "Select amount type",
                                    message: nil,
                                    preferredStyle: .actionSheet,
                                    actions: [ .dynamic(title: "Cash", style: .default, tag: 1),
                                               .dynamic(title: "Crypto", style: .default, tag: 2),
                                               .cancel()], animated: true)
        
        let destination = AlertDestination.alert(model: alertModel, presentationCompletion: nil) { [ weak self ] action in
            switch action {
            case .dynamic(_, _, _, tag: 1):
                self?.viewModel.updateAmountType(.fiat)
            case .dynamic(_, _, _, tag: 2):
                self?.viewModel.updateAmountType(.crypto)
            default:
                return
            }
        }
        
        navigator.goTo(destination)
    }
    
    private func goToCryptoPicker() {
        guard let selectedCoinPublisher = viewModel.setupModel.value?.headerModel.selectedCoinPublisher else { return }

        let destination = CryptoAccountDestination.cryptoPicker(coins: [],
                                                                selectedCrypto: selectedCoinPublisher)

        navigator.goTo(destination)
    }
    
    private func showPayingValidationErrorAlert(with message: String) {
        let alertModel = AlertModel(title: Constants.Localization.AcceptPaymentValidation.validationFailed, message: message,
                                    preferredStyle: .alert, actions: [.ok], animated: true)
        let destination = AlertDestination.alert(model: alertModel, presentationCompletion: nil, actionCompletion: nil)
        
        navigator.goTo(destination)
    }
    
    private func showPayingMinimumAmountValidationError(amount: Double) {
        let alertModel = AlertModel(title: Constants.Localization.AcceptPaymentValidation.validationFailed,
                                    message: Constants.Localization.AcceptPaymentValidation.useMinimumAmount(amount),
                                    preferredStyle: .alert, actions: [.no, .yes], animated: true)
        let destination = AlertDestination.alert(model: alertModel, presentationCompletion: nil) { [ weak self ] action in
            switch action {
            case .yes:
                self?.performTransaction(isRequesting: false, amount: amount)
            default:
                return
            }
        }
                
        navigator.goTo(destination)
    }
    
    private func goToChannelParticipantsScreen() {
        let users = viewModel.membersInfoHolderViewModel.participants.value
        
        navigator.goTo(ChannelsDestination.channelParticipantsList(users))
    }
    
    private func goToParticipantsPicker() {
        guard let mainPeer = viewModel.membersInfoHolderViewModel.participants.value.first else { return }
        var addedPeers = viewModel.membersInfoHolderViewModel.participants.value
        
        addedPeers.removeFirst()
        let destination = ChannelsDestination.participantPicker(true,
                                                                source: .payOrReqeust,
                                                                context: context,
                                                                mainPeer: mainPeer,
                                                                addedPeers: addedPeers)
        
        if let controller = destination.viewController as? ChannelParticipantsPickerViewController {
            controller.viewModel.additionalPeersPublisher
                .sink { [ weak self ] participants in
                    let newParticipants = [mainPeer] + participants
                    self?.viewModel.membersInfoHolderViewModel.participants.send(newParticipants)
                }
                .store(in: &controller.cancellables)
        }

        navigator.goTo(destination)
    }

    private func goToChat() {
        guard let peerId = self.viewModel.stateInfo.peerId else { return }
        
        let dataSignal: Signal<EnginePeer?, NoError> = context.engine.data.get(
            TelegramEngine.EngineData.Item.Peer.Peer(id: peerId)
        )
        |> map { peer -> (EnginePeer?) in
            return (peer)
        }

        let _ = (dataSignal |> deliverOnMainQueue)
            .start { [ weak self ] peer in
                guard let self, let peer else { return }
                
                var isChannel = false
                
                if case let .channel(peer) = peer,
                   case .broadcast = peer.info {
                    if peer.adminRights == nil {
                        isChannel = true
                    }
                }
                
                self.dismiss(animated: true) { [ weak self ] in
                    guard let self else { return }
                    let possiblePeerId = AppData.userTelegramPeerId ?? peerId.id._internalGetInt64Value()
                    let possibleExtraPeerId = AppData.userTelegramExtraPeerId ?? peerId.toInt64()
                    let newPeerId = isChannel ? possiblePeerId : peerId.id._internalGetInt64Value()
                    let newExtraPeerId = isChannel ? possibleExtraPeerId : peerId.toInt64()
                    NotificationCenter.default.post(name: .payOrRequestDidComplete, object: self, userInfo: ["peerId": newPeerId, "extraPeerId": newExtraPeerId])
                }
            }
    }
    
    private func handleUnAvailableCryptoReason(_ reason: UnavailableCryptoReason) {
        switch reason {
        case .error:
            showUnavailableCryptoErrorAlert()
        }
    }

    private func showUnavailableCryptoErrorAlert() {
        let alertModel = AlertModel(message: "Apologies, but the service is unavailable in your region", preferredStyle: .alert, actions: [.ok], animated: true)
        
        let destination = AlertDestination.alert(model: alertModel, presentationCompletion: nil, actionCompletion: nil)
        
        navigator.goTo(destination)
    }

    private func showCryptoAccountUpdateAlert() {
        let alertModel = AlertModel(title: "Incomplete Account", message: "You need to update your crypto account status", preferredStyle: .alert, actions: [.cancel(), .ok], animated: true)
        
        let destination = AlertDestination.alert(model: alertModel, presentationCompletion: nil) { [ weak self ] type in
            switch type {
            case .ok:
                self?.navigator.goTo(BackDestination.popToRoot(animated: true))
                NotificationCenter.default.post(name: .cryptoAccuntStatusUpdateShouldUpdated, object: self)
            default:
                return
            }
        }
        
        navigator.goTo(destination)
    }

    override func handleKeyboardFrameChange(isHidden: Bool, frame: CGRect, duration: Double, curve: UIView.AnimationCurve) {
        super.handleKeyboardFrameChange(isHidden: isHidden, frame: frame, duration: duration, curve: curve)
        
        guard !isHidden, let footer = self.footerView as? ChannelPaymentFooterView else { return }
        
        if !footer.notesTextField.isFirstResponder {
            self.scrollView.setContentOffset(.init(x: 0, y: 200), animated: true)
        }
    }
}

extension ChannelPaymentViewController: SFSafariViewControllerDelegate {
    public func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        guard let redirectingSource = viewModel.redirectingSource else {
            
            cleanUpRedirectingInfo()
            
            return
        }
        
        if redirectingSource == .accountConsent {
            viewModel.fetchAccountBalance()
        }

        cleanUpRedirectingInfo()
    }

    private func cleanUpRedirectingInfo() {
        AppData.payOrRequestStateInfo = nil
    }
}
