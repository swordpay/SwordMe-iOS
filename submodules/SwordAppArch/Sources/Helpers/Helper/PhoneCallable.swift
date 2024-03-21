//
//  PhoneCallable.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 11.05.22.
//

import UIKit

protocol PhoneCallable: NSObject {
    var navigator: Navigating { get }

    func tryToCall(to: String)
}

extension PhoneCallable {
    func tryToCall(to phoneNumber: String) {
        let image = UIImage(systemName: Constants.AssetName.Common.phone)
        let callAction = AlertModel.ButtonType.dynamic(title: "\(Constants.Localization.Common.call) \(phoneNumber)",
                                                       image: image,
                                                       style: .default,
                                                       tag: 0)
        let alertModel = AlertModel(title: nil,
                                    message: nil,
                                    preferredStyle: .actionSheet,
                                    actions: [callAction, .cancel(style: .destructive)],
                                    animated: true)

        let destination = AlertDestination.alert(model: alertModel,
                                                 presentationCompletion: nil,
                                                 actionCompletion: { [ weak self ] type in
                                                    switch type {
                                                    case .dynamic(_, _, _, _):
                                                        self?.call(to: phoneNumber)
                                                    default:
                                                        return
                                                    }
                                                })

        navigator.goTo(destination)
    }

    private func call(to phoneNumber: String) {
        if let url = URL(string: "tel://\(phoneNumber)"),
           UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}
