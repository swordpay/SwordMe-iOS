//
//  ActionableSystemServiceViewModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 06.06.22.
//

import Foundation

class ActionableSystemServiceViewModel: SystemServiceViewModel {
    var requestCompletion: Constants.Typealias.SystemServiceRequestCompletionHandler?
    var shouldDismissBeforeCompletion: Bool = true
}
