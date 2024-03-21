//
//  UITextField+Toolbar.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 20.09.22.
//

import UIKit

extension UITextField {
    func setupKeyboardToolbar() {
        let buttonTitle = Constants.Localization.Common.done
        let toolbar = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))

        toolbar.barStyle = .default
        toolbar.sizeToFit()

        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: buttonTitle, style: .plain, target: self, action: #selector(doneButtonHandler))
        ]

        inputAccessoryView = toolbar
    }

    @objc
    func doneButtonHandler() {
        print("Done button clicked \(self)")
        self.endEditing(true)
    }
}
