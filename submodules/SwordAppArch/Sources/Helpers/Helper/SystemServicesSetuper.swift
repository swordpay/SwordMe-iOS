//
//  SystemServicesSetuper.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 15.07.22.
//

import UIKit
import Combine

final class SystemServicesSetuper {

    private static var cancellables: Set<AnyCancellable> = []

    static func setup() {
        setupInternetService()
    }

    private static func setupInternetService() {
        InternetManagerProvider.reachability
            .internetRechabilityPublisher
            .receive(on: RunLoop.main)
            .sink { status in
                guard let status = status else { return }

                switch status {
                case .unreachable:
                    guard !isSystemServicePresenting() else { return }

                    let viewController = ViewControllerProvider.SystemService.internet

                    showControllerModally(viewController)
                case .reachable(_):
                    guard let viewController = UIApplication.shared.topMostViewController() as? SystemServiceViewController else { return }

                    viewController.dismiss(animated: true)
                }
            }
            .store(in: &cancellables)

        InternetManagerProvider.reachability.startNotifyer()
    }

    private static func isSystemServicePresenting() -> Bool {
        guard UIApplication.shared.topMostViewController() is SystemServiceViewController else { return false }

        return true
    }

    private static func showControllerModally<ViewModel: SystemServiceViewModel>(_ controller: SystemServiceViewController<ViewModel>) {
        controller.modalPresentationStyle = .fullScreen

        UIApplication.shared.topMostViewController()?
            .present(controller, animated: true, completion: nil)
    }
}
