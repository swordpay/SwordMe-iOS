//
//  CompletionViewModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 27.06.22.
//

import Combine
import Foundation

final class CompletionViewModel: BaseViewModel<Void>, StackViewModeling {
    typealias SetupModel = CompletionStackViewModel

    let dismissAction: Constants.Typealias.VoidHandler?
    var setupModel: CurrentValueSubject<CompletionStackViewModel?, Never>
    
    init(stackModel: CompletionStackViewModel, dismissAction: Constants.Typealias.VoidHandler?) {
        self.setupModel = CurrentValueSubject(stackModel)
        self.dismissAction = dismissAction

        super.init(inputs: ())
    }
}
