//
//  CardInfoItemViewModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 15.02.23.
//

import Foundation

final class CardInfoItemViewModel {
    let info: Info
    
    init(info: Info) {
        self.info = info
    }
}

extension CardInfoItemViewModel {
    struct Info {
        let title: String?
        let content: String
        let isCopiable: Bool
    }
}
