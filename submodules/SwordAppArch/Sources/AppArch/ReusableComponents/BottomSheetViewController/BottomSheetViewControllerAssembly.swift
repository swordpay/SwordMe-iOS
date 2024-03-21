//
//  BottomSheetViewControllerAssembly.swift
//  SwordAppArch
//
//  Created by Tigran Simonyan on 27.06.23.
//

import Swinject
import Foundation

final class BottomSheetViewControllerAssembly: Assembly {
    func assemble(container: Container) {
        container.register(BottomSheetViewModel.self) { _ in
            return BottomSheetViewModel(inputs: ())
        }
        
        container.register(BottomSheetViewController.self) { resolver in
            let viewModel = resolver.resolve(BottomSheetViewModel.self)!
            let viewController = BottomSheetViewController(viewModel: viewModel)
            
            return viewController
        }
    }
}
