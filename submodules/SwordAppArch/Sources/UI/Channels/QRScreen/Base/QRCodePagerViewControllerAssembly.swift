//
//  QRCodePagerViewControllerAssembly.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 09.02.23.
//

import Combine
import Swinject
import Foundation

final class QRCodePagerViewControllerAssembly: Assembly {
    let scanResultPublisher: PassthroughSubject<String?, Never>
    
    init(scanResultPublisher: PassthroughSubject<String?, Never>) {
        self.scanResultPublisher = scanResultPublisher
    }
    
    func assemble(container: Container) {
        let scanResultPublisher = self.scanResultPublisher
        
        container.register(QRCodePagerViewModel.self) { resolver in
            let viewModel = QRCodePagerViewModel(scanResultPublisher: scanResultPublisher)
            
            return viewModel
        }
     
        container.register(QRCodePagerViewController.self) { resolver in
            let viewModel = resolver.resolve(QRCodePagerViewModel.self)!
            let viewController = QRCodePagerViewController(viewModel: viewModel)
            
            return viewController
        }
    }
}
