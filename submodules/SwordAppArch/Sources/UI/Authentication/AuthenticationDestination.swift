//
//  AuthenticationDestination.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 19.01.23.
//

import UIKit
import Combine

enum AuthenticationDestination: Destinationing {
    case forgotPassword
    case resetPassword
    
    var viewController: UIViewController {
        switch self {
        case .forgotPassword:
            let viewController = ViewControllerProvider.Authentication.forgotPassword
            let navController = BaseNavigationController(rootViewController: viewController)
            
            return navController
        case .resetPassword:
            return ViewControllerProvider.Authentication.resetPassword
        }
    }
    
    var navigationType: NavigationType {
        switch self {
        case .forgotPassword:
            return .modal(presentationMode: .pageSheet)
        case .resetPassword:
            return .modal(presentationMode: .pageSheet)
        }
    }
}
