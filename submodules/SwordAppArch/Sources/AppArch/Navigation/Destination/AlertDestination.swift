//
//  AlertDestination.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 24.04.22.
//

import UIKit
import Display

public struct AlertModel {
    public enum ButtonType {
        case ok
        case cancel(style: UIAlertAction.Style = .destructive)
        case yes
        case no
        case input(title: String)
        case dynamic(title: String, image: UIImage? = nil, style: UIAlertAction.Style, tag: Int)

        var title: String {
            switch self {
            case .ok: return Constants.Localization.Common.ok
            case .cancel: return Constants.Localization.Common.cancel
            case .yes: return Constants.Localization.Common.yes
            case .no: return Constants.Localization.Common.no
            case let .input(title: title): return title
            case let .dynamic(title, _, _, _): return title
            }
        }

        var image: UIImage? {
            switch self {
            case let .dynamic(_, image, _, _): return image
            default: return nil
            }
        }

        var style: UIAlertAction.Style {
            switch self {
            case .ok: return .default
            case .yes: return .default
            case .no: return .cancel
            case .input(_): return .default
            case let .cancel(style): return style
            case let .dynamic(_, _, style, _): return style
            }
        }
    }

    public struct InputModel {
        var isInputable: Bool = false
        var placeholder: String = Constants.Localization.Common.placeholder
        var defaultText: String? = nil
        var keyboardType: UIKeyboardType
        let inputAccessoryView: UIView?
        var delegate: UITextFieldDelegate?

        public init(isInputable: Bool = false,
             placeholder: String = Constants.Localization.Common.placeholder,
             defaultText: String? = nil,
             keyboardType: UIKeyboardType = .default,
             inputAccessoryView: UIView? = nil,
             delegate: UITextFieldDelegate? = nil) {
            self.isInputable = isInputable
            self.placeholder = placeholder
            self.defaultText = defaultText
            self.keyboardType = keyboardType
            self.inputAccessoryView = inputAccessoryView
            self.delegate = delegate
        }
    }

    var title: String?
    var message: String?
    var preferredStyle: UIAlertController.Style
    var inputModel: InputModel = InputModel()
    var actions: [ButtonType]
    var animated: Bool
    
    public init(title: String? = nil, message: String? = nil, preferredStyle: UIAlertController.Style, inputModel: AlertModel.InputModel = InputModel(), actions: [AlertModel.ButtonType], animated: Bool) {
        self.title = title
        self.message = message
        self.preferredStyle = preferredStyle
        self.inputModel = inputModel
        self.actions = actions
        self.animated = animated
    }
}

public enum AlertDestination: CommonDestinationing {
    case alert(model: AlertModel,
               forcePresentFromRoot: Bool = false,
               inputHandler: ((String?) -> Void)? = nil,
               presentationCompletion: (() -> Void)?,
               actionCompletion: ((AlertModel.ButtonType) -> Void)?)
}

public extension AlertDestination {
    @discardableResult
    func handleNavigation(sourceViewController: UIViewController?) -> UIViewController? {
        guard let sourceViewController = sourceViewController else {
            print("sourceViewController is nil")

            return nil
        }

        switch self {
        case let .alert(model, forcePresentFromRoot, inputHandler, presentationCompletion, actionCompletion):
            let alertController = UIAlertController(title: model.title, message: model.message, preferredStyle: model.preferredStyle)
            let actions = model.actions.isEmpty ? [.ok] : model.actions

            if model.inputModel.isInputable {
                alertController.addTextField { textField in
                    textField.text = model.inputModel.defaultText
                    textField.placeholder = model.inputModel.placeholder
                    textField.keyboardType = model.inputModel.keyboardType
                    textField.delegate = model.inputModel.delegate
                    textField.inputAccessoryView = model.inputModel.inputAccessoryView
                }
            }

            actions.forEach { buttonType in
                let alertAction = UIAlertAction.init(title: buttonType.title, style: buttonType.style) { _ in
                    if case .input = buttonType {
                        let text = alertController.textFields?.first?.text
                        inputHandler?(text)
                    }

                    actionCompletion?(buttonType)
                }

                alertAction.setValue(buttonType.image, forKey: "image")
                alertController.addAction(alertAction)
            }

            guard !forcePresentFromRoot else {
                sourceViewController.present(alertController, animated: model.animated, completion: presentationCompletion)
                
                return alertController
            }

            if let viewController = sourceViewController as? ViewController, viewController.presentingViewController != nil {
                viewController.presentNotFromRoot(alertController, animated: model.animated, completion: presentationCompletion)
            } else {
                sourceViewController.present(alertController, animated: model.animated, completion: presentationCompletion)
            }

            return alertController
        }
    }
}
