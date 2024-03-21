//
//  ViewControllerProvider+SystemService.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 18.04.22.
//

import Swinject
import Foundation

extension ViewControllerProvider {
    enum SystemService {
        static func camera(shouldDismissBeforeCompletion: Bool = true,
                                 with requestCompletion: Constants.Typealias.SystemServiceRequestCompletionHandler? = nil) -> SystemServiceCameraViewController {
            let assemblies: [Assembly] = [CameraServicePresentationModelAssembly(),
                                          SystemServiceCameraScreenViewControllerAssembly(shouldDismissBeforeCompletion: shouldDismissBeforeCompletion,
                                                                                                requestCompletion: requestCompletion)]
            let assembler = Assembler(assemblies)

            return assembler.resolver.resolve(SystemServiceCameraViewController.self)!
        }
        
        static var internet: SystemServiceViewController<SystemServiceViewModel> {
            let assemblies: [Assembly] = [InternetServicePresentationModelAssembly(),
                                          SystemServiceScreenViewControllerAssembly()]
            let assembler = Assembler(assemblies)

            return assembler.resolver.resolve(SystemServiceViewController.self)!
        }
    }
}
