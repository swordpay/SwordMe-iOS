//
//  MultiActionedInfoViewModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 08.12.22.
//

import Combine
import Foundation

protocol MultiActionedInfoViewModeling: StackViewModeling {
    var title: String { get }
    var stackSetupModel: MultiActionedInfoStackViewModel.SetupModel { get }
    
    func prepareContent()
}

class MultiActionedInfoViewModel<Inputs>: BaseViewModel<Inputs>, MultiActionedInfoViewModeling {
    var setupModel: CurrentValueSubject<MultiActionedInfoStackViewModel?, Never> = CurrentValueSubject(nil)
    
    var title: String {
        fatalError("This method must be implemented in children")
    }
    
    var stackSetupModel: MultiActionedInfoStackViewModel.SetupModel {
        fatalError("This method must be implemented in children")
    }

    func prepareContent() {
        setupModel.send(MultiActionedInfoStackViewModel(setupModel: stackSetupModel))
        setupBindings()
    }
    
    func setupBindings() {
        
    }
}
