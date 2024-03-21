//
//  QRScannerViewController.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 08.02.23.
//

import UIKit
import AVKit
//import FirebaseDynamicLinks

// MARK: - SwordChanges // Need to integrate firebase
final class QRScannerViewController: GenericStackViewController<QRScannerViewModel, QRScannerStackView> {
    // MARK: - Properties
    
    override var shouldRespectSafeArea: Bool { return false }
    
    override func emptyStateViewProvider() -> UIView? {
        guard let emptyView = SystemServicePermissionAccessView.loadFromNib() else { return nil }

        emptyView.setup(with: viewModel.emptyStateViewModel)

        return emptyView
    }
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CameraManagerProvider.native.checkAuthorizationStatus()
    }
    
    // MARK: - Binding
    
    override func bindViewModel() {
        super.bindViewModel()
        
        bindToSetupModel()
        bindToCameraAuthorizationStatus()
    }
    
    private func bindToSetupModel() {
        viewModel.setupModel
            .sink { [ weak self ] model in
                guard let self, model != nil else { return }
                
                self.configureSetupModelBindings()
            }
            .store(in: &cancellables)
    }

    private func configureSetupModelBindings() {
        bindToResultPublisher()
        bindToCloseButtonPublisher()
    }

    private func bindToCloseButtonPublisher() {
        viewModel.setupModel.value?.closeButtonActionPublisher
            .sink { [ weak self ] in
                self?.dismiss()
            }
            .store(in: &cancellables)
    }
    
    private func bindToResultPublisher() {
        viewModel.setupModel.value?.resultPublisher
            .throttle(for: .seconds(0.5), scheduler: DispatchQueue.main, latest: true)
            .removeDuplicates()
            .sink { [ weak self ] result in
                guard let result else { return }
                
                self?.viewModel.resultPublisher.send(result)
                self?.dismissTopController()
            }
            .store(in: &cancellables)
    }
    
    private func bindToCameraAuthorizationStatus() {
        CameraManagerProvider.native.authorizationStatusPublisher
            .receive(on: RunLoop.main)
            .sink { [ weak self ] status in
                guard let self,
                      let status else { return }

                switch status {
                case .authorized:
                    self.viewModel.setupModel.send(.init(.init(hasCloseButton: self.viewModel.hasCloseButton)))
                case .unauthorized:
                    self.viewModel.isEmptyState.send(true)
                case .notDetermined:
                    CameraManagerProvider.native.authorizeCameraAccess()
                }
            }.store(in: &cancellables)
    }

    // MARK: - Caputre Session Managing
    
    func startSession() {
        stackView.startSession()
    }
    
    func stopSession() {
        stackView.stopSession()
    }

    // MARK: - Navigation
    
    private func dismissTopController() {
        UIApplication.shared.topMostViewController()?.dismiss(animated: true)
    }
}
