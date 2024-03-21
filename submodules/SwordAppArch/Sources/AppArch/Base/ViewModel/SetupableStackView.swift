//
//  Setupable.swift
//  sword-ios
//
//  Created by Scylla IOS on 31.05.22.
//

import Foundation
import Combine

public protocol StackViewModeling: ViewModeling {
    associatedtype SetupModel
    
    var setupModel: CurrentValueSubject<SetupModel?, Never> { get set }
}
