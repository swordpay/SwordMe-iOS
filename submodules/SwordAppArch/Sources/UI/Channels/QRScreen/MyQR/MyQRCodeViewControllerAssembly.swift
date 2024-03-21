//
//  MyQRCodeViewControllerAssembly.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 09.02.23.
//

import Swinject
import Foundation

public final class MyQRCodeViewControllerAssembly: Assembly {
    let username: String?
    
    init(username: String?) {
        self.username = username
    }

    public func assemble(container: Container) {
        let username = self.username

        container.register(MyQRCodeViewModel.self) { resolver in
            let downloadManager = resolver.resolve(DataDownloadManaging.self)!
            let inputs = MyQRCodeViewModelInputs(downloadManager: downloadManager)
            let viewModel = MyQRCodeViewModel(inputs: inputs, username: username)
            
            return viewModel
        }
     
        container.register(MyQRCodeViewController.self) { resolver in
            let viewModel = resolver.resolve(MyQRCodeViewModel.self)!
            let viewController = MyQRCodeViewController(viewModel: viewModel)
                        
            return viewController
        }
    }
}
