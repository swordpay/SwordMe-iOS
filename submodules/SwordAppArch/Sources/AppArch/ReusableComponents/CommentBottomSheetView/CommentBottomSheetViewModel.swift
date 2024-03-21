//
//  CommentBottomSheetViewModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 29.12.22.
//

import Combine
import Foundation

final class CommentBottomSheetViewModel {
    let cancelButtonPublisher: PassthroughSubject<Void, Never> = PassthroughSubject()
    let rightSideButtonPublisher: PassthroughSubject<Void, Never> = PassthroughSubject()

    let rightSideButtonTitle: String
    let title: String
    let description: String?
    let comment: CurrentValueSubject<String?, Never> = CurrentValueSubject(nil)

    var commentTextFieldAttributedPlaceholder: NSAttributedString {
        let currentTheme = ThemeProvider.currentTheme

        return NSAttributedString(string: Constants.Localization.Channels.notesPlaceholder,
                                  attributes: [.foregroundColor: currentTheme.colors.textColor.withAlphaComponent(0.6),
                                               .font: currentTheme.fonts.rubikItalic(ofSize: 17)])
    }
    init(rightSideButtonTitle: String, title: String, description: String?) {
        self.rightSideButtonTitle = rightSideButtonTitle
        self.title = title
        self.description = description
    }
}
