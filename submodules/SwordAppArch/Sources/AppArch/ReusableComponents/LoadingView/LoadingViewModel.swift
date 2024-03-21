//
//  LoadingViewModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 24.05.22.
//

import Foundation
import Combine

final class LoadingViewModel {
    let isLoading: CurrentValueSubject<Bool, Never>
    let hasCustomIndicator: Bool
    
    init(isLoading: Bool, hasCustomIndicator: Bool = false) {
        self.isLoading = CurrentValueSubject(isLoading)
        self.hasCustomIndicator = hasCustomIndicator
    }
}
