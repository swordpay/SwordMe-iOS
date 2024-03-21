//
//  BaseVC.swift
//  sword-ios
//
//  Created by Scylla IOS on 20.05.22.
//

import UIKit
import Combine
import Display
import TelegramUIPreferences

open class BaseViewController<ViewModel: ViewModeling>: ViewController, Navigatable {

    // MARK: - Properties

    open var viewModel: ViewModel!
    open var cancellables: Set<AnyCancellable> = []
    public lazy var navigator: Navigating = BaseNavigation(sourceViewController: self)

    var loadingView: LoadingView?

    var bottomSheetPresentor: BottomSheetPresentor?

    var hasCustomLoadingIndicator: Bool {
        return false
    }

    public init(viewModel: ViewModel? = nil) {
        self.viewModel = viewModel

        super.init(navigationBarPresentationData: .init(theme: .init(buttonColor: ThemeProvider.currentTheme.colors.gradientDarkBlue,
                                                                     disabledButtonColor: ThemeProvider.currentTheme.colors.textColor,
                                                                     primaryTextColor: ThemeProvider.currentTheme.colors.textColor,
                                                                     backgroundColor: ThemeProvider.currentTheme.colors.mainWhite,
                                                                     enableBackgroundBlur: false,
                                                                     separatorColor: .clear,
                                                                     badgeBackgroundColor: ThemeProvider.currentTheme.colors.mainRed,
                                                                     badgeStrokeColor: ThemeProvider.currentTheme.colors.mainWhite,
                                                                     badgeTextColor: ThemeProvider.currentTheme.colors.mainWhite),
                                                        strings: .init(presentationStrings: .init())))
        
        self.supportedOrientations = .init(regularSize: .portrait, compactSize: .portrait)
        self.lockOrientation = true
    }

    public init(viewModel: ViewModel? = nil, navigationBarPresentationData: NavigationBarPresentationData?) {
        self.viewModel = viewModel
        
        super.init(navigationBarPresentationData: navigationBarPresentationData)
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var emptyStateHolderView: UIView = {
        let view = UIView()
        
        view.backgroundColor = .clear
        view.isHidden = true

        return view
    }()
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLoadingView(isLoading: false)
    }

    open override func displayNodeDidLoad() {
        super.displayNodeDidLoad()
        
        bindViewModel()
        setupEmptyStateView()
        
        view.backgroundColor = theme.colors.mainWhite
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let loadingView {
            view.bringSubviewToFront(loadingView)
        }
        
        navigationBar?.backButtonNode.updateManualText("Back", isBack: true)
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        view.endEditing(true)
        
        lockOrientation = true
        lockedOrientation = . portrait
    }

    // MARK: - Setup UI
    
    func emptyStateViewProvider() -> UIView? {
        return nil
    }
    
    func setupEmptyStateView() {
        guard let emptyView = emptyStateViewProvider() else { return }
        
        emptyStateHolderView.subviews.forEach { $0.removeFromSuperview() }
        emptyStateHolderView.isHidden = true
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        emptyStateHolderView.addSubview(emptyView)
        emptyView.addBorderConstraints(constraintSides: .all)
    }
    
    // MARK: - Binding

    open func bindViewModel() {
        bindEmptyState()
        bindError()
        bindToLoading()
    }

    private func bindEmptyState() {
        viewModel.isEmptyState
            .sink(receiveValue: { [ weak self ] isEmptyState in
                self?.handleEmptyState(isEmptyState)
            })
            .store(in: &cancellables)
    }

    // MARK: - Handler Empty State

    func handleEmptyState(_ isEmptyState: Bool) {

    }

    private func bindError() {
        viewModel.error
            .sink { [ weak self ] error in
                guard let error else { return }
                
                if let networkError = error as? DataFetchingError,
                   case .refreshingFailed = networkError {
                    return
                }

                self?.handleError(error)
            }
            .store(in: &cancellables)
    }

    // MARK: - Handler Error

    func handleError(_ error: Error) {
        let errorViewModel = viewModel.errorViewModel(for: error)
        
        let alertModel = AlertModel(title: errorViewModel.title,
                                    message: errorViewModel.message,
                                    preferredStyle: .alert,
                                    actions: [.ok],
                                    animated: true)
        
        let destination = AlertDestination.alert(model: alertModel, presentationCompletion: nil) { _ in
            errorViewModel.action()
        }
        
        navigator.goTo(destination)
    }

    // MARK: - Handler Loading

    func bindToLoading(){
        viewModel.isLoading
            .filter { $0 != nil }
            .sink { [ weak self ] isLoading in
                self?.handleLoading(isLoading!)
            }
            .store(in: &(cancellables))
    }
        
    func handleLoading(_ isLoading: Bool) {
        let alpha: Double = isLoading ? 1 : 0
        
        self.loadingView?.model.isLoading.send(isLoading)
//        
        UIView.animate(withDuration: 0.2) {
            self.loadingView?.alpha = alpha
        }
    }
    
    private func configureLoadingView(isLoading: Bool) {
        guard loadingView == nil,
              let loadingView = LoadingView.loadFromNib() else { return }

        let model = LoadingViewModel(isLoading: isLoading, hasCustomIndicator: hasCustomLoadingIndicator)

        loadingView.setup(with: model)

        loadingView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingView)
        loadingView.addBorderConstraints(constraintSides: .all)

        loadingView.alpha = 0
        view.bringSubviewToFront(loadingView)

        self.loadingView = loadingView
    }
}

// MARK: - Bottom Sheet

extension BaseViewController: BottomSheetPresentable {
    func presentAsBottomSheet(_ view: UIView, on parentView: UIView? = nil, height: CGFloat, onDismiss: Constants.Typealias.VoidHandler? = nil) {
        bottomSheetPresentor = BottomSheetPresentor()
        bottomSheetPresentor?.present(view, on: parentView, height: height, onDismiss: onDismiss)
    }

    func dismissBottomSheet(completion: Constants.Typealias.VoidHandler? = nil) {
        bottomSheetPresentor?.dismiss { [ weak self ] in
            completion?()
            self?.bottomSheetPresentor = nil
        }
    }
}
