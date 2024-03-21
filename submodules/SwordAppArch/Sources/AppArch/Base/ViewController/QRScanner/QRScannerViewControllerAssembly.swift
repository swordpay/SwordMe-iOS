//
//  QRScannerViewControllerAssembly.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 08.02.23.
//

import Combine
import Swinject
import Foundation

public final class QRScannerViewControllerAssembly: Assembly {
    let resultPublisher: PassthroughSubject<String?, Never>
    let hasCloseButton: Bool
    
    init(hasCloseButton: Bool, resultPublisher: PassthroughSubject<String?, Never>) {
        self.hasCloseButton = hasCloseButton
        self.resultPublisher = resultPublisher
    }

    public func assemble(container: Container) {
        let resultPublisher = resultPublisher
        let hasCloseButton = hasCloseButton

        container.register(QRScannerViewModel.self) { resolver in
            return QRScannerViewModel(hasCloseButton: hasCloseButton,
                                      resultPublisher: resultPublisher)
        }

        container.register(QRScannerViewController.self) { resolver in
            let viewModel = resolver.resolve(QRScannerViewModel.self)!
            let viewController = QRScannerViewController(viewModel: viewModel)
            
            return viewController
        }
    }
}
