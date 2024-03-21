//
//  SearchBarHeaderViewModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 21.12.22.
//

import Combine
import Foundation

final class SearchBarHeaderViewModel {
    let searchTerm: CurrentValueSubject<String?, Never> = CurrentValueSubject(nil)
    let searchCancelPublisher: PassthroughSubject<Void, Never> = PassthroughSubject()

    var placeholder: String
    
    var isLoading: CurrentValueSubject<Bool, Never> = CurrentValueSubject(false)
    var isSearchActive: CurrentValueSubject<Bool, Never> = CurrentValueSubject(false)
    
    var attributedPlaceholder: NSAttributedString {
        let currentTheme = ThemeProvider.currentTheme
        return NSAttributedString(string: placeholder,
                                  attributes: [.font: currentTheme.fonts.font(style: .placeholder, family: .poppins, weight: .regular),
                                               .foregroundColor: currentTheme.colors.mainGray4])
    }
    
    var hasTerm: Bool {
        guard let searchTerm = searchTerm.value,
              !searchTerm.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return false }
        
        return true
    }
    
    init(placeholder: String) {
        self.placeholder = placeholder
    }
}
