//
//  PagerViewModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 05.12.22.
//

import Combine
import Foundation

final class PagerViewModel {
    var currentPage: CurrentValueSubject<Int, Never>
    var numberOfPages: Int
    
    init(currentPage: Int, numberOfPages: Int) {
        self.currentPage = CurrentValueSubject(currentPage)
        self.numberOfPages = numberOfPages
    }
}
