//
//  ChannelRequestDetailsHeaderItemViewModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 28.12.22.
//

import Foundation

final class ChannelRequestDetailsHeaderItemViewModel {
    let title: String
    let attributedDescription: NSAttributedString
    
    init(title: String, attributedDescription: NSAttributedString) {
        self.title = title
        self.attributedDescription = attributedDescription
    }
}
