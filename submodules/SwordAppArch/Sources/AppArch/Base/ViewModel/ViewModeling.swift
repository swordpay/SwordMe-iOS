//
//  ViewModeling.swift
//  sword-ios
//
//  Created by Scylla IOS on 25.05.22.
//

import Foundation
import Combine

public protocol ViewModeling {
    var error: PassthroughSubject<Error?, Never> { get }
    var isLoading: CurrentValueSubject<Bool?, Never> { get }
    var isEmptyState: CurrentValueSubject<Bool, Never> { get }

    func errorViewModel(for error: Error) -> ErrorViewModel
}
