//
//  TextValidating.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 01.06.22.
//

import Foundation

public enum TextValidationResultState: Equatable {
    case success
    case failure(String)
}

public protocol TextValidating {
    func validate(_ text: String?) -> Constants.Typealias.TextValidationResult
}
