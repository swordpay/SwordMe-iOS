//
//  HomeContainerViewController.swift
//  ChatListUI
//
//  Created by Tigran Simonyan on 02.08.23.
//

import UIKit
import Display
import Combine
import SwordAppArch
import AccountContext
import TelegramPresentationData

private final class BundleHelper: NSObject {
}

public final class HomeContainerViewController: ViewController {
    private var bundle: Bundle {
        let mainBundle = Bundle(for: BundleHelper.self)
        guard let path = mainBundle.path(forResource: "ChatListUIBundle", ofType: "bundle") else {
            fatalError("Cant get bundle")
        }
        guard let bundle = Bundle(path: path) else {
            fatalError("Cant get bundle")
        }

        return bundle
    }

    var context: AccountContext
    private var presentationData: PresentationData
    private var cancellables: Set<AnyCancellable> = []
    private var enableDebugActions: Bool
    
    private var headerView: HomeHeaderView?
    private var headerViewSetupModel: HomeHeaderViewModel = .init(recentsSetupModel: .init(recentChannels: []))
    private var footerView: ChannelsActionsBottomView?
    
    private var pageController: UIPageViewController?
    private(set) lazy var controllers: [UIViewController] = {
        return [ chatViewController ]
    }()

    lazy var chatViewController: ChatListController = {
        return context.sharedContext.makeChatListController(context: context,
                                                            location: .chatList(groupId: .root),
                                                            controlsHistoryPreload: true,
                                                            hideNetworkActivityStatus: false,
                                                            previewing: false,
                                                            enableDebugActions: enableDebugActions)
    }()
    
    public init(context: AccountContext, enableDebugActions: Bool) {
        self.context = context
        self.enableDebugActions = enableDebugActions
        self.presentationData = context.sharedContext.currentPresentationData.with { $0 }
        
        super.init(navigationBarPresentationData: .init(theme: .init(buttonColor: ThemeProvider.currentTheme.colors.textBlue,
                                                                     disabledButtonColor: ThemeProvider.currentTheme.colors.textColor,
                                                                     primaryTextColor: ThemeProvider.currentTheme.colors.textColor,
                                                                     backgroundColor: ThemeProvider.currentTheme.colors.mainWhite,
                                                                     enableBackgroundBlur: false,
                                                                     separatorColor: .clear,
                                                                     badgeBackgroundColor: ThemeProvider.currentTheme.colors.mainRed,
                                                                     badgeStrokeColor: ThemeProvider.currentTheme.colors.mainWhite,
                                                                     badgeTextColor: ThemeProvider.currentTheme.colors.mainWhite),
                                                        strings: .init(presentationStrings: .init())))

        
        self.tabBarItemContextActionType = .always

        self.statusBar.statusBarStyle = .Black

        self.tabBarItem.title = "Home"
        
        let icon = UIImage(imageName: "tabbar-channels-icon")

        self.tabBarItem.image = icon
        self.tabBarItem.selectedImage = icon
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func displayNodeDidLoad() {
        super.displayNodeDidLoad()
        
        setupHeaderView()
        setupFooterView()
        setupPageViewController()
    }

    private func setupHeaderView() {
        guard let headerView = HomeHeaderView.loadFromNib(bundle: bundle) else { return }
        
        headerView.setup(with: headerViewSetupModel)
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(headerView)
        
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        headerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 70).isActive = true
        
        self.headerView = headerView
        
        bindToHeaderViewModel()
    }
    
    private func bindToHeaderViewModel() {
        headerViewSetupModel.selectedTabIndex
            .sink { [ weak self ] index in
                guard let self else { return }
                let isSelectedScanner = index == 0
                let direction: UIPageViewController.NavigationDirection = isSelectedScanner ? .reverse : .forward
                let selectedVC = self.controllers[index]
                
                self.pageController?.setViewControllers([selectedVC],
                                                         direction: direction,
                                                         animated: true)
            }.store(in: &cancellables)
    }

    private func setupFooterView() {
        guard let bottomView = ChannelsActionsBottomView.loadFromNib() else { return }
        
        bottomView.setup(with: .init())
                        
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(bottomView)
        
        NSLayoutConstraint.activate([
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -85).isActive = true
        
        self.footerView = bottomView
    }
    
    
    private func setupPageViewController() {
        guard let headerView,
              let footerView else { return }
            
        let controller = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        controller.view.backgroundColor = .clear
        view.addSubview(controller.view)
        controller.view.translatesAutoresizingMaskIntoConstraints = false

        controller.view.addBorderConstraints(constraintSides: .horizontal)
        controller.setViewControllers([controllers[0]], direction: .forward, animated: true)

        NSLayoutConstraint.activate([
            controller.view.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            controller.view.bottomAnchor.constraint(equalTo: footerView.topAnchor)
        ])

        disablePagerScrolling(pageController: controller)
        self.pageController = controller
    }

    private func disablePagerScrolling(pageController: UIPageViewController) {
        for case let scrollView as UIScrollView in pageController.view.subviews {
            scrollView.isScrollEnabled = false
        }
    }
}
