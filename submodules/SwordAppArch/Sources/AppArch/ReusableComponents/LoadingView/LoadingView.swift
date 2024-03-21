//
//  LoadingView.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 24.05.22.
//

import UIKit
import Combine
import Display
import RadialStatusNode

final class LoadingView: SetupableView {
    typealias SetupModel = LoadingViewModel
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var indicatorHolderView: UIView!
    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var customLoadinIndicatorViewHolder: UIView!
    
    // MARK: - Properties
    
    private lazy var customActivityIindicator: RadialStatusNode = .init(backgroundNodeColor: .clear)
    
    private var cancellables: Set<AnyCancellable> = []
    private(set) var model: LoadingViewModel!
    
    // MARK: - Setup UI
    
    func setup(with model: LoadingViewModel) {
        self.model = model
        
        setupActivityIndicator()
        bindToIsLoading()
        indicatorHolderView.setCornerRadius()
    }
    
    private func setupActivityIndicator() {
        if model.hasCustomIndicator {
            loadingIndicator.isHidden = true
            setupCustomActivityIndicator()
        }
    }

    private func setupCustomActivityIndicator() {
        indicatorHolderView.backgroundColor = .clear
        customLoadinIndicatorViewHolder.isHidden = false
        customActivityIindicator.view.translatesAutoresizingMaskIntoConstraints = false
        customLoadinIndicatorViewHolder.addSubview(customActivityIindicator.view)
        customActivityIindicator.view.addBorderConstraints(constraintSides: .all)
    }
    
    // MARK: - Binding
    
    private func bindToIsLoading() {
        model.isLoading
            .sink(receiveValue: handleStateChange(isLoading:))
            .store(in: &cancellables)
    }
    
    private func handleStateChange(isLoading: Bool) {
        let alpha = isLoading ? 1.0 : 0.0

        self.alpha = alpha

        isLoading ? self.startAnimation() : self.stopAnimation()
    }

    private func startAnimation() {
        if model.hasCustomIndicator {
            customActivityIindicator.transitionToState(.progress(color: theme.colors.mainWhite, lineWidth: 4, value: 0.75, cancelEnabled: false, animateRotation: true))
        } else {
            loadingIndicator.startAnimating()
        }
    }
    
    private func stopAnimation() {
        if model.hasCustomIndicator {
            customActivityIindicator.transitionToState(.none)
        } else {
            loadingIndicator.stopAnimating()
        }
    }
}
