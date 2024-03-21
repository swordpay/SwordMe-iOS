//
//  HomeViewController.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 04.05.23.
//

import UIKit
import Combine
import Display
import SwordAppArch
import AccountContext
import SwiftSignalKit
import TelegramPresentationData

private final class BundleHelper: NSObject {
}

public final class HomeViewController: GenericStackViewController<HomeViewModel, HomeStackView> {
    // MARK: - Properties
    
    public override var bundle: Bundle {
        let mainBundle = Bundle(for: BundleHelper.self)
        guard let path = mainBundle.path(forResource: "ChatListUIBundle", ofType: "bundle") else {
            fatalError("Cant get bundle")
        }
        guard let bundle = Bundle(path: path) else {
            fatalError("Cant get bundle")
        }

        return bundle
    }
    
    public override var shouldEmbedInScrollView: Bool { return false }

    private var deepLinkHandlerCancellable: AnyCancellable?
    var context: AccountContext
    private var presentationData: PresentationData
    private var presentationDataDisposable: Disposable?

    public init(viewModel: HomeViewModel, context: AccountContext) {
        self.context = context
        
        self.presentationData = context.sharedContext.currentPresentationData.with { $0 }
        
        super.init(viewModel: viewModel,
                   navigationBarPresentationData: NavigationBarPresentationData(presentationData: presentationData))
        
        self.tabBarItemContextActionType = .always

        self.statusBar.statusBarStyle = .Black

        self.tabBarItem.title = "Home"
        
        let icon = UIImage(bundleImageName: "tabbar-channels-icon")

        self.tabBarItem.image = icon
        self.tabBarItem.selectedImage = icon

        self.presentationDataDisposable = (context.sharedContext.presentationData
        |> deliverOnMainQueue).start(next: { [weak self] presentationData in
            if let strongSelf = self {
                let previousTheme = strongSelf.presentationData.theme
                let previousStrings = strongSelf.presentationData.strings
                
                strongSelf.presentationData = presentationData
                
                if previousTheme !== presentationData.theme || previousStrings !== presentationData.strings {
                    strongSelf.updateThemeAndStrings()
                }
            }
        })
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        presentationDataDisposable?.dispose()
    }

    // MARK: - Lifecycle Methods

    public override func displayNodeDidLoad() {
        super.displayNodeDidLoad()
//
//        setupHeaderView()
//        setupFooterView()
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Home viewDidLoad")
    }

//    public override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        navigationController?.setNavigationBarHidden(true, animated: false)
//    }
//
//    public override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//
//        navigationController?.setNavigationBarHidden(false, animated: false)
//    }

    // MARK: - Setup UI
    
    private func updateThemeAndStrings() {
        self.statusBar.statusBarStyle = .Black
    }

    private func setupHeaderView() {
        guard let headerView = HomeHeaderView.loadFromNib(bundle: bundle) else { return }
        
        headerView.setup(with: viewModel.headerModel)
        
        self.headerView = headerView
    }

    private func setupFooterView() {
        guard let bottomView = ChannelsActionsBottomView.loadFromNib() else { return }
        
        bottomView.setup(with: viewModel.actionsButtomViewModel)
                
        self.footerView = bottomView
    }
    
    // MARK: - Binding
    
    public override func bindViewModel() {
        super.bindViewModel()
        
        bindToSelectedChannel()
        bindToSearchBarTapHandler()
        bindToHeaderModelScanQRAction()
        bindToPayOrRequestButtonPublisher()
    }
    
    private func bindToPayOrRequestButtonPublisher() {
        viewModel.actionsButtomViewModel.payOrRequestButtonPublisher
            .sink { [ weak self ] in
                self?.goToParticipantPickerScreen(isForMultipleSelection: true, source: .payOrReqeust)
            }
            .store(in: &cancellables)
    }
    
    private func bindToHeaderModelScanQRAction() {
        viewModel.headerModel.scanQRTapHandler
            .sink { [ weak self ] in
                self?.goToQRScannerScreen()
            }
            .store(in: &cancellables)
    }
    
    private func bindToSelectedChannel() {
//        guard let firstController = stackView.controllers.first as? ChannelsViewController else { return }
//
//        firstController.viewModel.selectedChannel
//            .sink { [ weak self ] channel in
//                self?.goToChatScreen(channelItem: channel)
//            }
//            .store(in: &cancellables)
    }
    
    private func bindToInviteFriends(emptyStateViewModel: ChannelsEmptyStateViewModel) {
        emptyStateViewModel.inviteFriendsPublisher
            .sink { [ weak self ] in
                self?.goToInviteFriendsScreen()
            }
            .store(in: &cancellables)
    }
    
    private func bindToSearchBarTapHandler() {
        viewModel.headerModel.searchBarTapHandler
            .sink { [ weak self ] in
                self?.goToParticipantPickerScreen(isForMultipleSelection: true, source: .channelsList)
            }
            .store(in: &cancellables)
    }

    // MARK: - Navigation
    
    private func goToInviteFriendsScreen() {
        navigator.goTo(ChannelsDestination.inviteFriends)
    }

//    @discardableResult
//    private func goToChatScreen(channelItem: ChannelItemModel) -> UIViewController {
//        let destination = ChannelsDestination.chat(channelItem, source: .channelsList)
//
//        let controller = destination.viewController
//
//        navigator.goTo(destination)
//
//        return controller
//    }

    private func goToQRScannerScreen() {
        let controller = CommonDestination.qrCodePager(scanResultPublisher: viewModel.scanResultPublisher).viewController
        
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }
    
    private func goToParticipantPickerScreen(isForMultipleSelection: Bool,
                                             source: ChannelParticipantsPickerSource) {
        navigator.goTo(ChannelsDestination.participantPicker(isForMultipleSelection,
                                                             source: source,
                                                             context: nil,
                                                             mainPeer: nil, addedPeers: []))
    }
    
    private func goToPayOrRequestScreen(stateInfo: PayOrRequestStateInfoModel) -> UIViewController? {
        let destination = ChannelsDestination.channelPayment(stateInfo: stateInfo)
        
        navigator.goTo(destination)
        
        return destination.viewController
    }
    
    private func showEmailVerificationResultAlert(isSucceeded: Bool) {
        let message = isSucceeded ? Constants.Localization.Profile.verifyEmailTokenSuccess
                                  : Constants.Localization.Profile.verifyEmailTokenFail

        let alertModel = AlertModel(title: Constants.Localization.Common.information,
                                    message: message,
                                    preferredStyle: .alert,
                                    actions: [.ok],
                                    animated: true)
        let destination = AlertDestination.alert(model: alertModel, presentationCompletion: nil, actionCompletion: nil)
        
        navigator.goTo(destination)
    }
    
    private func showInvalidUserAlert() {
        let alertModel = AlertModel(title: nil,
                                    message: Constants.Localization.Channels.unknownUser,
                                    preferredStyle: .alert,
                                    actions: [.ok],
                                    animated: true)
        let destination = AlertDestination.alert(model: alertModel, presentationCompletion: nil, actionCompletion: nil)
        
        navigator.goTo(destination)
    }
}

extension HomeViewController: Deeplinking {
    public func deeplink(to dest: DeeplinkDestinationing, completion: @escaping (UIViewController?) -> Void) {
//        guard let channelsDestination = dest as? ChannelsDeeplinkDestination else {
//            completion(nil)
//
//            return
//        }
//
//        switch channelsDestination {
//        case .payOrReqeust(let username):
//            guard username != AppData.currentUserInfo?.username else {
//                completion(nil)
//
//                return
//            }
//
//            self.viewModel.fetchUser(by: username) { [ weak self ] user in
//                guard let self else {
//                    completion(nil)
//
//                    return
//                }
//
//                guard let user else {
//                    self.showInvalidUserAlert()
//
//                    completion(nil)
//
//                    return
//                }
//
//                let stateInfo = self.viewModel.payOrReqeustStateInfo(from: user)
//                let controller = self.goToPayOrRequestScreen(stateInfo: stateInfo)
//
//                completion(controller)
//            }
//        case .chat(let channelItem):
//            return
////            let controller = self.goToChatScreen(channelItem: channelItem)
////            completion(controller)
//        case .payOrRequest(let stateInfo):
//            let controller = self.goToPayOrRequestScreen(stateInfo: stateInfo)
//
//            completion(controller)
//        case .verifyEmail(let token):
//            viewModel.verifyEmailToken(token) { [ weak self ] result in
//                if AppData.currentUserInfo != nil {
//                    AppData.currentUserInfo?.isEmailVerified = result
//                } else {
//                    self?.viewModel.getUserInfo()
//                }
//
//                self?.showEmailVerificationResultAlert(isSucceeded: result)
//
//                completion(nil)
//            }
//        }
    }
}
