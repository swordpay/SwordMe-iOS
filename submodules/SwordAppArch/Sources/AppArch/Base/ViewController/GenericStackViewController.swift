//
//  GenericStackViewController.swift
//  sword-ios
//
//  Created by Scylla IOS on 31.05.22.
//

import UIKit
import Combine
import Display

public typealias SetupableStackView = UIStackView & Setupable

open class GenericStackViewController<ViewModel: StackViewModeling, StackView: SetupableStackView>: HeaderFooterViewController<ViewModel>, UIScrollViewDelegate where ViewModel.SetupModel == StackView.SetupModel {
    
    // MARK: - Properties

    private(set) lazy var scrollView = UIScrollView()
    private var isKeyboardVisible: Bool = false

    public lazy var stackView = StackView.loadFromNib(bundle: bundle)! // TODO: - Maybe this should be changed
    open var shouldEmbedInScrollView: Bool { return true }
    var scrollViewContentInset: UIEdgeInsets { return .zero }
    var needToOverrideKeyboardChangesHandler: Bool { return true }
    
    open var bundle: Bundle {
        return Constants.mainBundle
    }
    
    // MARK: - Init
    
    public override init(viewModel: ViewModel? = nil) {
        super.init(viewModel: viewModel)
    }
    
    public override init(viewModel: ViewModel? = nil, navigationBarPresentationData: NavigationBarPresentationData?) {
        super.init(viewModel: viewModel, navigationBarPresentationData: navigationBarPresentationData)
    }

    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle Methods

    open override func viewDidLoad() {
        super.viewDidLoad()
        
        addEndEditingTapGesture()
    }
    
    open override func displayNodeDidLoad() {
        super.displayNodeDidLoad()
        
        setupContent()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - Setup UI

    public func updateStackView(with model: ViewModel.SetupModel) {
        stackView.setup(with: model)
    }
    
    private func setupContent() {
        contentView?.subviews.forEach { $0.removeFromSuperview() }
        
        guard shouldEmbedInScrollView else {
            contentView = stackView

            return
        }

        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)
        scrollView.delegate = self
        scrollView.contentInset = scrollViewContentInset

        stackView.addBorderConstraints(constraintSides: .all)
        contentView = scrollView
        
        let heightConstraint = stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        heightConstraint.priority = .defaultHigh

        NSLayoutConstraint.activate([
            heightConstraint,
            stackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
        ])
    }
    
    func addEndEditingTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(stackViewTapHandler))

        contentView?.addGestureRecognizer(tapGesture)
    }

    @objc
    private func stackViewTapHandler() {
        if isKeyboardVisible {
            view.endEditing(true)
        }
    }

    // MARK: - Binding

    open override func bindViewModel() {
        super.bindViewModel()

        bindStackViewModel()
    }

    func bindStackViewModel() {
        viewModel.setupModel
            .receive(on: RunLoop.main)
            .sink { [ weak self ] setupModel in
                guard let self else { return }
                
                guard let setupModel else {
                    
                    self.viewModel.isEmptyState.send(true)

                    return
                }
                
                self.viewModel.isEmptyState.send(false)

                if self.contentView == self.stackView {
                    self.updateStackView(with: setupModel)
                } else {
                    self.updateStackView(with: setupModel)
//                    self.setupContent(with: setupModel)
                }
            }.store(in: &cancellables)
    }
    
    
    // MARK: - ScrollView Delegate

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {

    }

    // MARK: - Handle Keyboard Frame Changes
    
    override func handleKeyboardFrameChange(isHidden: Bool, frame: CGRect, duration: Double, curve: UIView.AnimationCurve) {
        guard needToOverrideKeyboardChangesHandler else {
            super.handleKeyboardFrameChange(isHidden: isHidden, frame: frame, duration: duration, curve: curve)

            return
        }

        guard shouldEmbedInScrollView else {
            super.handleKeyboardFrameChange(isHidden: isHidden, frame: frame, duration: duration, curve: curve)

            isKeyboardVisible = !isHidden

            return
        }

        let stackViewBottomInset = isHidden ? 0 : frame.size.height
        let animator = UIViewPropertyAnimator(duration: duration,
                                              curve: curve) { [ weak self ] in
            self?.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: stackViewBottomInset, right: 0)
        }

        animator.startAnimation()

        isKeyboardVisible = !isHidden
    }
}
