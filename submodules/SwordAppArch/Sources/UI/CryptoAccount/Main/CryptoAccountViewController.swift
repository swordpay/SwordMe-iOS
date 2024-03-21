//
//  CryptoAccountViewController.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 20.12.22.
//

import UIKit
import Combine
import Display
import TabBarUI
import MessageUI
import AccountContext
import SwiftSignalKit
import TelegramPresentationData

public final class CryptoAccountViewController: GenericTableViewController<CryptoAccountViewModel, TitledTableHeaderAndFooterView, CryptoItemCell, EmptyHeaderAndFooterView>, EmailSendable {
    
    // MARK: - Properties
        
    var context: AccountContext
    
    private var deepLinkHandlerCancellable: AnyCancellable?
    override var headerContainerViewInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: -10, right: 0)
    }
    
    override var contentContainerViewInsets: UIEdgeInsets {
        let bottomOffset: CGFloat = (UIApplication.shared.rootViewController()?.view.safeAreaInsets.top ?? 0) + 44
        
        return UIEdgeInsets(top: 0, left: 0, bottom: bottomOffset, right: 0)
    }
    
    override var headerContainerViewNavigationTopInset: CGFloat {
        return UIApplication.shared.rootViewController()?.view.safeAreaInsets.top ?? 20
    }
    
    private var shimmerLoadingView: CryptoShimmerLoadingView?

    override func emptyStateViewProvider() -> UIView? {
        guard let emptyView = TextedEmptyStateView.loadFromNib() else { return nil }
        
        emptyView.setup(with: viewModel.emptyStateModel)
        

        return emptyView
    }
    
    public init(viewModel: CryptoAccountViewModel, context: AccountContext) {
        self.context = context
        
        let navPresentationData: NavigationBarPresentationData = .init(theme: .init(buttonColor: ThemeProvider.currentTheme.colors.gradientDarkBlue,
                                                                                    disabledButtonColor: ThemeProvider.currentTheme.colors.textColor,
                                                                                    primaryTextColor: ThemeProvider.currentTheme.colors.textColor,
                                                                                    backgroundColor: ThemeProvider.currentTheme.colors.mainWhite,
                                                                                    enableBackgroundBlur: false,
                                                                                    separatorColor: .clear,
                                                                                    badgeBackgroundColor: ThemeProvider.currentTheme.colors.mainRed,
                                                                                    badgeStrokeColor: ThemeProvider.currentTheme.colors.mainWhite,
                                                                                    badgeTextColor: ThemeProvider.currentTheme.colors.mainWhite),
                                                                       strings: .init(presentationStrings: .init()))
        super.init(viewModel: viewModel,
                   navigationBarPresentationData: navPresentationData)
        
        self.tabBarItemContextActionType = .always
        
        self.statusBar.statusBarStyle = .Black
        
        self.tabBarItem.title = "Crypto"
        
        let icon = UIImage(imageName: Constants.AssetName.TabBar.cryptoAccount)
        
        self.tabBarItem.image = icon
        self.tabBarItem.selectedImage = icon
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle Methods
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        //        viewModel.prepareAccountInfo()
    }
    
    public override func displayNodeDidLoad() {
        super.displayNodeDidLoad()
        
        viewModel.prepareAccountInfo()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setDisplayNavigationBar(false)

        viewModel.updateData()
        viewModel.startTimer()
        tabBarController?.tabBar.isHidden = false
        forceAnimateShimmerIfNeeded()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        updateSubscriptions()
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        setDisplayNavigationBar(true)
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        viewModel.stopTimer()
    }
    
    // MARK: - Setup UI
    
    override func handleEmptyState(_ isEmptyState: Bool) {
        setupEmptyStateView()
        
        super.handleEmptyState(isEmptyState)
    }

    override func handleLoading(_ isLoading: Bool) {
        guard !viewModel.isLoadingAfterRedirection else {
            super.handleLoading(isLoading)
            
            return
        }

        guard isLoading else {
            shimmerLoadingView?.removeFromSuperview()
            shimmerLoadingView = nil
            
            return
        }

        guard let shimmerLoadingView = CryptoShimmerLoadingView.loadFromNib() else {
            super.handleLoading(isLoading)

            return
        }

        shimmerLoadingView.setup(with: ())

        shimmerLoadingView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(shimmerLoadingView)
        shimmerLoadingView.addBorderConstraints(constraintSides: .all, by: .init(top: 0, left: 0, bottom: 0, right: 0))
        
        self.shimmerLoadingView = shimmerLoadingView
    }
    
    func forceAnimateShimmerIfNeeded() {
        if let shimmerLoadingView  {
            shimmerLoadingView.forceAnimate()
        }
    }

    private func setupHeaderView(with model: CryptoAccountHeaderViewModel) {
        guard let headerView = CryptoAccountHeaderView.loadFromNib() else { return }
        
        headerView.setup(with: model)
        
        self.headerView = headerView
    }
    
    // MARK: - Binding
    
    public override func bindViewModel() {
        super.bindViewModel()
        
        bindToHeaderModel()
        bindToSocketConnection()
        bindToTradeDataPublisher()
        bindToTickerDataPublisher()
        bindToAppStateNotification()
    }
    
    private func bindToHeaderModel() {
        viewModel.headerViewModel
            .filter { $0 != nil }
            .sink { [ weak self ] model in
                self?.setupHeaderView(with: model!)
            }
            .store(in: &cancellables)
    }
    
    private func bindToTradeDataPublisher() {
        viewModel.tradeDataPublisher
        //            .throttle(for: .seconds(1.5), scheduler: DispatchQueue.main, latest: true)
            .receive(on: RunLoop.main)
            .sink { [ weak self ] value in
                guard let self,
                      let mainCoin = self.viewModel.mainCoin,
                      let model = value as? TradeSocketResponse,
                      model.symbols == "EUR\(mainCoin)",
                      let price = Double(model.price) else { return }
                
                self.viewModel.updateVisibleItems(at: (self.tableView.indexPathsForVisibleRows ?? []),
                                                  newMainPrice: 1 / price)
            }
            .store(in: &cancellables)
    }
    
    private func bindToTickerDataPublisher() {
        viewModel.tickerDataPublisher
        //            .throttle(for: .seconds(1.5), scheduler: DispatchQueue.main, latest: true)
            .receive(on: RunLoop.main)
            .sink { [ weak self ] value in
                guard let self,
                      let model = value as? MiniTickerSocketResponse else { return }
                
                self.viewModel.updateVisibleCellPriceChangesIfNeeded(model: model,
                                                                     visibleCellsIndexPaths: (self.tableView.indexPathsForVisibleRows ?? []))
            }
            .store(in: &cancellables)
    }
    
    private func bindToSocketConnection() {
        WebSocketManager.global.isConnected
            .sink { [ weak self ] isConnected in
                guard let self else { return }
                
                if isConnected {
                    self.viewModel.reconnectStreams(visibleCellsIndexPaths: self.tableView.indexPathsForVisibleRows ?? [])
                } else {
                    WebSocketManager.global.connect()
                }
            }
            .store(in: &cancellables)
    }
    
    private func bindToAppStateNotification() {
        NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)
            .sink { _ in
                WebSocketManager.global.connect()
            }
            .store(in: &cancellables)
        
        NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)
            .sink { _ in
                WebSocketManager.global.disconect()
            }
            .store(in: &cancellables)
        
        InternetManagerProvider.reachability.internetRechabilityPublisher
            .sink { status in
                if let status, case .reachable = status {
                    WebSocketManager.global.connect()
                } else {
                    WebSocketManager.global.disconect()
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Navigation
    
    private func sendEMailToSupport() {
        sendEmail(to: Constants.AppURL.supportEmail, subject: "Support", body: nil, attachment: nil)
    }

    @discardableResult
    private func goToCryptoDetails(cryptoInfo: CryptoModel) -> UIViewController? {
        guard let cryptoAssetsResponse = viewModel.cryptoAssetsResponse,
              let mainCoinName = viewModel.mainCoin,
              let mainCoinPrice = viewModel.mainCoinPriceInEuro else { return nil }

        let destination = CryptoAccountDestination.details(allCryptos: cryptoAssetsResponse,
                                                           cryptoInfo: cryptoInfo,
                                                           mainCoinInfo: .init(name: mainCoinName,
                                                                               price: mainCoinPrice))
        let controller = destination.viewController

        navigator.goTo(destination)
        
        return controller
    }
        
    // MARK: - TableView Delegate
  
    public override func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach {
            if let cellModel = viewModel.cellModel(for: $0) {
                cellModel.prepareCryptoImageData()
            }
        }
    }

    // MARK: - Table View Delegate & DataSource
        
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cryptoInfo = viewModel.cellModel(for: indexPath)?.cryptoModel else { return }
        
        goToCryptoDetails(cryptoInfo: cryptoInfo)
    }
    
    public override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        updateSubscriptions()
    }
    
    public override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        updateSubscriptions()
    }
    
    private func updateSubscriptions() {
        viewModel.subscribeToCryptoPricesChanges(force: false, at: viewModel.visibleIndexPaths)
        
        viewModel.subscribeToCryptoPricesChanges(force: true, at: tableView.indexPathsForVisibleRows ?? [])
        viewModel.visibleIndexPaths = tableView.indexPathsForVisibleRows ?? []
    }
}

extension CryptoAccountViewController: Deeplinking {
    public func deeplink(to dest: DeeplinkDestinationing, completion: @escaping (UIViewController?) -> Void) {
        guard let accountDestination = dest as? CryptoAccountDeeplinkDestination else {
            completion(nil)

            return
        }
        
        switch accountDestination {
        case .account:
            completion(nil)
            deepLinkHandlerCancellable = nil
        case .cryptoDetails(let queryItems), .buyCrypto(let queryItems):
            guard let selectedCrypto = viewModel.getSelectedCrypto(from: queryItems) else {
                completion(nil)
                
                return
            }

            let vc = goToCryptoDetails(cryptoInfo: selectedCrypto)
            
            completion(vc)
            
            deepLinkHandlerCancellable = nil
        }
    }
}

extension CryptoAccountViewController: MFMailComposeViewControllerDelegate {
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
