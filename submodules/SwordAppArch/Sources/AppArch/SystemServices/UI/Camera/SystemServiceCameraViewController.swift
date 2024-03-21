//
//  SystemServiceCameraViewController.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 20.04.22.
//

import UIKit

final class SystemServiceCameraViewController: ActionableSystemServiceViewController {
    // MARK: - Setup Notification

    override func setupNotifications() {
        CameraManagerProvider.native.authorizationStatusPublisher
            .sink { [ weak self ] authorizationStatus in
                guard let self = self, authorizationStatus == .authorized else { return }

                self.completionHandler()
            }
            .store(in: &cancellables)
    }
}
