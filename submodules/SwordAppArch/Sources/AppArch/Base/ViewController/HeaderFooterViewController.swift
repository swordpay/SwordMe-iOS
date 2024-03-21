//
//  HeaderFooterViewController.swift
//  sword-ios
//
//  Created by Scylla IOS on 26.05.22.
//

import UIKit
import Combine
import Display

open class HeaderFooterViewController<ViewModel: ViewModeling>: BaseViewController<ViewModel> {
    
    var shouldRespectSafeArea: Bool { return true }
    var shouldHandleKeyboardNotifications: Bool { return true }
    
    private var safeAreaBottomInset: CGFloat {
        guard shouldRespectSafeArea else { return 0 }
        
        return view.safeAreaInsets.bottom
    }

    public override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge {
        return .left
    }

    private(set) lazy var headerContainerView: UIView = emptyView()
    private(set) lazy var contentContainerView: UIView = emptyView()
    private(set) lazy var footerContainerView: UIView = emptyView()
    
    private var headerContainerHeightConstraint: NSLayoutConstraint? 
    private var footerContainerHeightConstraint: NSLayoutConstraint?
    private var footerContainerBottomContstraint: NSLayoutConstraint?

    private var notificationCancellable: AnyCancellable?

    open var headerView: UIView? {
        didSet {
            oldValue?.removeFromSuperview()
            setupHeaderView()
        }
    }
    
    open var contentView: UIView? {
        didSet {
            oldValue?.removeFromSuperview()
            setupContentView()
        }
    }
    
    open var footerView: UIView? {
        didSet {
            oldValue?.removeFromSuperview()
            footerContainerHeightConstraint?.isActive = true
            setupFooterView()
        }
    }

    var headerContainerViewInsets: UIEdgeInsets {
        return .zero
    }

    var headerContainerViewNavigationTopInset: CGFloat {
        return 0
    }

    var contentContainerViewInsets: UIEdgeInsets {
        return .zero
    }

    var footerContainerViewInsets: UIEdgeInsets {
        return .zero
    }
    
    public override init(viewModel: ViewModel? = nil) {
        super.init(viewModel: viewModel)
    }
    
    public override init(viewModel: ViewModel? = nil, navigationBarPresentationData: NavigationBarPresentationData?) {
        super.init(viewModel: viewModel, navigationBarPresentationData: navigationBarPresentationData)
    }

    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        setupConteinerViews()
        setupContentView()
    }
    
    open override func displayNodeDidLoad() {
        super.displayNodeDidLoad()
        
        if !isViewLoaded {
            setupConteinerViews()
            setupContentView()
        }
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupKeyboardNotifications()
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        notificationCancellable = nil
    }
    
    // MARK: - Empty State Handling

    override func handleEmptyState(_ isEmptyState: Bool) {
        if isEmptyState {
            emptyStateHolderView.translatesAutoresizingMaskIntoConstraints = false
            emptyStateHolderView.isHidden = false
            contentContainerView.addSubview(emptyStateHolderView)
            emptyStateHolderView.addBorderConstraints(constraintSides: .all)
        } else {
            emptyStateHolderView.removeFromSuperview()
            emptyStateHolderView.isHidden = true
        }
    }

    private var isContainersSetup: Bool = false

    private func setupConteinerViews() {
        guard !isContainersSetup else { return }
        
        isContainersSetup = true

        setupContentConteiner()
        setupHeaderContainer()
        setupFooterContainer()
    }
    
    private func emptyView() -> UIView {
        let emptyView = UIView()
        
        emptyView.backgroundColor = .clear
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        displayNode.view.addSubview(emptyView)
        
        return emptyView
    }

    private func setupHeaderContainer() {
        let borderSides: ViewBorder

        if let navigationBar {
            headerContainerView.topAnchor.constraint(equalTo: navigationBar.view.bottomAnchor,
                                                     constant: headerContainerViewNavigationTopInset).isActive = true
            
            borderSides = .horizontal
        } else {
            borderSides = [.horizontal, .top]
        }

        headerContainerView.addBorderConstraints(constraintSides: borderSides,
                                         by: headerContainerViewInsets,
                                         shouldRespectSafeArea: shouldRespectSafeArea)

        headerContainerHeightConstraint = headerContainerView.heightAnchor.constraint(equalToConstant: 0)
        headerContainerHeightConstraint?.isActive = true
    }

    private func setupFooterContainer() {
        let borderSides: ViewBorder = [.horizontal]
        footerContainerView.addBorderConstraints(constraintSides: borderSides,
                                                 by: footerContainerViewInsets,
                                                 shouldRespectSafeArea: shouldRespectSafeArea)

        guard let superView = footerContainerView.superview else { return }
        let bottomAnchor: NSLayoutYAxisAnchor
        let guide = view.safeAreaLayoutGuide

        lazy var defaultAnchor: NSLayoutYAxisAnchor = {
            return shouldRespectSafeArea ? guide.bottomAnchor : superView.bottomAnchor
        }()

        if #available(iOS 15.0, *) {
            bottomAnchor = shouldHandleKeyboardNotifications ? defaultAnchor : view.keyboardLayoutGuide.topAnchor
        } else {
            bottomAnchor = defaultAnchor
        }
        
        footerContainerBottomContstraint = footerContainerView.bottomAnchor.constraint(equalTo: bottomAnchor,
                                                                                       constant: footerContainerViewInsets.bottom)
        
        footerContainerBottomContstraint?.isActive = true
        footerContainerHeightConstraint = footerContainerView.heightAnchor.constraint(equalToConstant: 0)
        footerContainerHeightConstraint?.isActive = true
    }
    
    private func setupContentConteiner() {
        contentContainerView = emptyView()

        let borderSides: ViewBorder = .horizontal

        contentContainerView.addBorderConstraints(constraintSides: borderSides, by: contentContainerViewInsets)

        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: headerContainerView,
                               attribute: .bottom,
                               relatedBy: .equal,
                               toItem: contentContainerView,
                               attribute: .top,
                               multiplier: 1.0,
                               constant: contentContainerViewInsets.top + headerContainerViewInsets.bottom),
            NSLayoutConstraint(item: footerContainerView,
                               attribute: .top,
                               relatedBy: .equal,
                               toItem: contentContainerView,
                               attribute: .bottom,
                               multiplier: 1.0,
                               constant: contentContainerViewInsets.bottom + footerContainerViewInsets.top)
        ])
    }

    private func setupHeaderView() {
        guard let headerView = headerView else {
            headerContainerHeightConstraint?.isActive = true
            
            return
        }
        
        headerContainerHeightConstraint?.isActive = false
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerContainerView.addSubview(headerView)
        headerView.addBorderConstraints(constraintSides: .all)
    }
    
    private func setupContentView() {
        guard let contentView = contentView else { return }
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        contentContainerView.addSubview(contentView)
        contentView.addBorderConstraints(constraintSides: .all)
    }
    
    private func setupFooterView() {
        guard let footerView = footerView else {
            footerContainerHeightConstraint?.isActive = true
            
            return
        }
        
        footerContainerHeightConstraint?.isActive = false
        footerView.translatesAutoresizingMaskIntoConstraints = false
        footerContainerView.addSubview(footerView)
        footerView.addBorderConstraints(constraintSides: .all)
    }

    // MARK: - Handle Keyboard Frame Changes

    func handleKeyboardFrameChange(isHidden: Bool, frame: CGRect, duration: Double, curve: UIView.AnimationCurve) {
        let bottomInset = isHidden ? -footerContainerViewInsets.bottom : frame.size.height + 10 - safeAreaBottomInset

        let animator = UIViewPropertyAnimator(duration: duration,
                                              curve: curve) { [ weak self ] in
            self?.footerContainerBottomContstraint?.constant = -bottomInset
            self?.view.layoutIfNeeded()
        }

        animator.startAnimation()
    }
}

// MARK: - Setup Keyboard Notifications

extension HeaderFooterViewController {
    public func setupKeyboardNotifications() {
        guard shouldHandleKeyboardNotifications else { return }

        let defaultNotifications = NotificationCenter.default

        let cancellable = defaultNotifications
            .publisher(for: UIResponder.keyboardWillShowNotification, object: nil)
            .merge(with: defaultNotifications.publisher(for: UIResponder.keyboardWillHideNotification, object: nil))
            .sink(receiveValue: { [ weak self ] notification in
                self?.handleKeyboardNotification(notification)
            })

        notificationCancellable = cancellable
    }

    func handleKeyboardNotification(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        
        let keyboardFrameScreenCoordinates = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        let animationCurve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as! Int
        let keyboardDidHide = notification.name == UIResponder.keyboardWillHideNotification

        handleKeyboardFrameChange(isHidden: keyboardDidHide,
                                  frame: keyboardFrameScreenCoordinates,
                                  duration: animationDuration,
                                  curve: UIView.AnimationCurve(rawValue: animationCurve)!)
    }
}
