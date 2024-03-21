//
//  IndeterminateProgressView.swift
//  SwordAppArch
//
//  Created by Tigran Simonyan on 08.02.24.
//

import UIKit
import Combine

public final class IndeterminateProgressView: SetupableView {
    //MARK: - IBOutlets
    
    @IBOutlet private weak var trackView: UIView!
    @IBOutlet private weak var progressView: UIView!
    @IBOutlet private weak var animatableProgressView: UIView!

    @IBOutlet private weak var progressViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet private weak var animatableProgressViewLeadingConstraint: NSLayoutConstraint!
    
    // MARK: - Properties
    
    private var model: IndeterminateProgressViewModel!
    private var cancellables: Set<AnyCancellable> = []
    
    public func setup(with model: IndeterminateProgressViewModel) {
        self.model = model

        let cornerRadius = trackView.frame.height / 2
        trackView.setCornerRadius(cornerRadius)
        trackView.backgroundColor = model.trackTintColor
        
        progressView.setCornerRadius(cornerRadius)
        progressView.backgroundColor = model.progressTintColor
        
        animatableProgressView.setCornerRadius(cornerRadius)
        animatableProgressView.backgroundColor = model.progressTintColor

        bindToProgress()
    }
    
    func startAnimateProcessing() {
        progressView.isHidden = true
        animatableProgressView.isHidden = true
        self.animatableProgressViewLeadingConstraint.constant = -animatableProgressView.frame.width
        
        layoutIfNeeded()
        
        UIView.animate(withDuration: 1, delay: 0.1, options: .curveEaseInOut) {
            self.animatableProgressView.isHidden = false
            self.animatableProgressViewLeadingConstraint.constant = self.trackView.frame.width
            self.layoutIfNeeded()
        } completion: { [ weak self ] _ in
            self?.startAnimateProcessing()
        }
    }

    // MARK: - Binding
    
    private func bindToProgress() {
        model.progress
            .sink { [ weak self ] progress in
                guard let self else { return }
                
                self.progressViewWidthConstraint.constant = progress * self.trackView.frame.width
                
                UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) {
                    self.layoutIfNeeded()
                }
            }
            .store(in: &cancellables)
    }
} 
