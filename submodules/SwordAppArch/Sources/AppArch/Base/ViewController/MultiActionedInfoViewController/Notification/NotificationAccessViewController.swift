//
//  NotificationAccessViewController.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 27.01.23.
//

import Foundation

final class NotificationAccessViewController: MultiActionedInfoViewController<NotificationAccessViewModel> {
    // MARK: - Binding
    
    override func bindViewModel() {
        super.bindViewModel()
        
        bindToMaybeLayerAction()
        bindToNotificationStatusChange()
    }
    
    private func bindToNotificationStatusChange() {
        NotificationManagerProvider.native.authorizationStatusPublisher
            .receive(on: RunLoop.main)
            .filter { $0 != nil }
            .sink { [ weak self ] status in
                self?.goToNextStep()
            }
            .store(in: &cancellables)
    }

    private func bindToMaybeLayerAction() {
        viewModel.maybeLaterHandler
            .sink { [ weak self ] in
                self?.goToNextStep()
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Navigation
    
    private func goToNextStep() {
    }
}
