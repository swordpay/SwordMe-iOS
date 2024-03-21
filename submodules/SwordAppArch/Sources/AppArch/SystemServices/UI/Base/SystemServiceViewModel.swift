//
//  SystemServiceViewModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 18.04.22.
//

import Foundation
import Combine

class SystemServiceViewModel: BaseViewModel<Void>, StackViewModeling {
    var setupModel: CurrentValueSubject<SystemServiceStackView.SetupModel?, Never>

    var hasAction: Bool { setupModel.value?.info.hasAction ?? false }

    init(systemServiceInfo: SystemServicePresentationModel) {
        let setupModel = SystemServiceStackView.SetupModel(info: systemServiceInfo)
        self.setupModel = CurrentValueSubject(setupModel)

        super.init(inputs: ())
    }
}
