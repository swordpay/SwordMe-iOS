//
//  ProgressAlertViewModel.swift
//  SwordAppArch
//
//  Created by Tigran Simonyan on 08.02.24.
//

import Combine
import Foundation

public final class ProgressAlertViewModel {
    let title: CurrentValueSubject<String, Never>
    let message: CurrentValueSubject<String?, Never>
    let progressSetupModel: IndeterminateProgressViewModel

    let actionName: CurrentValueSubject<String?, Never>
    let isActionenabled: CurrentValueSubject<Bool, Never> = .init(true)
    let actionTapHandler: PassthroughSubject<Void, Never> = .init()
    
    init(title: String, message: String? = nil, progressSetupModel: IndeterminateProgressViewModel, actionName: String? = nil) {
        self.title = CurrentValueSubject(title)
        self.message = CurrentValueSubject(message)
        self.progressSetupModel = progressSetupModel
        self.actionName = CurrentValueSubject(actionName)
    }
}
