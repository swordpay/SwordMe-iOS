//
//  ProgressAlertView.swift
//  SwordAppArch
//
//  Created by Tigran Simonyan on 08.02.24.
//

import UIKit
import Combine

public final class ProgressAlertView: SetupableView {
    // MARK: - IBOutlets
    
    @IBOutlet private var holderView: UIView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var messageLabel: UILabel!
    @IBOutlet private var progressHolderView: UIView!
    @IBOutlet private var actionButton: UIButton!
    
    // MARK: - Properties
    
    private var model: ProgressAlertViewModel!
    private var cancellables: Set<AnyCancellable> = []
    private var progressView: IndeterminateProgressView?
    
    // MARK: - Setup UI
    
    public func setup(with model: ProgressAlertViewModel) {
        self.model = model
        
        holderView.setCornerRadius(10)
        
        setupProgressView()
        
        bindToTitle()
        bindToMessage()
        bindToActionName()
    }

    private func setupProgressView() {
        guard let progressView = IndeterminateProgressView.loadFromNib() else {
            progressHolderView.isHidden = true
            
            return
        }
        
        progressHolderView.isHidden = false

        progressView.setup(with: model.progressSetupModel)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressHolderView.addSubview(progressView)
        progressView.addBorderConstraints(constraintSides: .all)
        
        self.progressView = progressView
    }

    func startProcessing() {
        progressView?.startAnimateProcessing()
    }

    // MARK: - Binding
    
    private func bindToTitle() {
        model.title
            .sink { [ weak self ] title in
                self?.titleLabel.text = title
            }
            .store(in: &cancellables)
    }
    
    private func bindToMessage() {
        model.message
            .sink { [ weak self ] message in
                guard let message else {
                    self?.messageLabel.isHidden = true
                    
                    return
                }
                
                self?.messageLabel.isHidden = false
                self?.messageLabel.text = message
            }
            .store(in: &cancellables)
    }

    private func bindToActionName() {
        model.actionName
            .sink { [ weak self ] actionName in
                guard let actionName else {
                    self?.actionButton.isHidden = true
                    
                    return
                }
                
                self?.actionButton.isHidden = false
                self?.actionButton.setTitle(actionName, for: .normal)
            }
            .store(in: &cancellables)
    }

    private func bindToIsActionenabled() {
        model.isActionenabled
            .sink { [ weak self ] isActionenabled in
                self?.actionButton.isUserInteractionEnabled = isActionenabled
            }
            .store(in: &cancellables)
    }

    // MARK: - Actions
    
    @IBAction private func actionButtonTouchUp(_ sender: UIButton) {
        model.actionTapHandler.send(())
    }
}
