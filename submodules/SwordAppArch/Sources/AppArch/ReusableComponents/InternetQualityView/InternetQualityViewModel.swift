//
//  InternetQualityViewModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 24.05.23.
//

import Combine
import Foundation

public final class InternetQualityViewModel {
    var internetQuality: CurrentValueSubject<InternetQuality, Never> = .init(.normal)
    public var networkState: CurrentValueSubject<NetworkState, Never> = .init(.online)
    
    public init() {
        
    }
}
