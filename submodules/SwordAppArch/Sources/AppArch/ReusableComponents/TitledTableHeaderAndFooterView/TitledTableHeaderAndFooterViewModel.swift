//
//  TitledTableHeaderAndFooterViewModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 21.12.22.
//

import UIKit

public class TitledTableHeaderAndFooterViewModel: TitledReusableViewModel {
    public override var isEmpty: Bool { return title.value.isEmpty }

    let font: UIFont
    let textAlignment: NSTextAlignment
    let backgroundColor: UIColor

    init(title: String,
         font: UIFont = ThemeProvider.currentTheme.fonts.regular(ofSize: 16, family: .poppins),
         textAlignment: NSTextAlignment = .left,
         backgroundColor: UIColor = ThemeProvider.currentTheme.colors.backgroundGray) {
        self.font = font
        self.textAlignment = textAlignment
        self.backgroundColor = backgroundColor

        super.init(title: title)
    }
}
