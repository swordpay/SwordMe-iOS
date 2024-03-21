//
//  SegmentedControllItemSetupModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 26.12.22.
//

import UIKit
import Combine

final class SegmentedControllItemSetupModel {
    let setupModel: SegmentedControlSetupModel.ItemModel
    let selectionPublisher: PassthroughSubject<Void, Never> = PassthroughSubject()
    let style: SegmentedControlSetupModel.Style
    let form: SegmentedControlSetupModel.Form
    let fontSize: SegmentedControlSetupModel.FontSize
    
    var font: UIFont {
        switch form {
        case .oval:
            let fontSize: CGFloat = fontSize == .small ? 14 : UIScreen.hasSmallScreen ? 16 : 22

            return ThemeProvider.currentTheme.fonts.semibold(ofSize: fontSize, family: .poppins)
        case .roundedRect:
            return ThemeProvider.currentTheme.fonts.medium(ofSize: 14, family: .poppins)
        }
    }
    init(setupModel: SegmentedControlSetupModel.ItemModel,
         style: SegmentedControlSetupModel.Style,
         form: SegmentedControlSetupModel.Form = .oval,
         fontSize: SegmentedControlSetupModel.FontSize) {
        self.setupModel = setupModel
        self.style = style
        self.form = form
        self.fontSize = fontSize
    }
}
