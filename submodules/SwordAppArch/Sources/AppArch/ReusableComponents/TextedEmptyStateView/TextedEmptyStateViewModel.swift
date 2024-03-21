//
//  TextedEmptyStateViewModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 04.05.23.
//

import Combine
import Foundation

final class TextedEmptyStateViewModel {
    let title: CurrentValueSubject<String, Never>
    let description: CurrentValueSubject<String?, Never>
    let hasImage: Bool
    let actionTitle: CurrentValueSubject<String?, Never>
    
    lazy var actionTapHandler: PassthroughSubject<Void, Never> = .init()
    
    init(title: String, description: String? = nil, hasImage: Bool = false, actionTitle: String? = nil) {
        self.title = .init(title)
        self.description = .init(description)
        self.hasImage = hasImage
        self.actionTitle = .init(actionTitle)
    }
}
