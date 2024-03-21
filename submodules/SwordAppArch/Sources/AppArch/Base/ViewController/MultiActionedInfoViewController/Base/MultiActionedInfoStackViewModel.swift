//
//  MultiActionedInfoStackViewModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 08.12.22.
//

import Combine
import Foundation

final class MultiActionedInfoStackViewModel {
    private var cancellables: Set<AnyCancellable> = []

    let setupModel: SetupModel
    
    let primaryButtonActionHandler: PassthroughSubject<Void, Never> = PassthroughSubject()
    let secondaryButtonActionHandler: PassthroughSubject<Void, Never> = PassthroughSubject()
        
    init(setupModel: SetupModel) {
        self.setupModel = setupModel
    }
    
    lazy var primaryButtonViewModel: GradientedButtonModel? = {
        guard let primaryButtonTitle = setupModel.primaryButtonTitle else { return nil }
        
        return GradientedButtonModel(title: primaryButtonTitle,
                                     hasBorders: false,
                                     isActive: !setupModel.hasPrivacyPolicy,
                                     action: { [ weak self ] in
            self?.primaryButtonActionHandler.send(())
        })
    }()
}

extension MultiActionedInfoStackViewModel {
    struct SetupModel {
        let mainIconName: String
        let topDescription: String?
        let topDescriptionIconName: String?
        let bottomDescription: String?
        let bottomDescriptionFontSize: CGFloat
        let primaryButtonTitle: String?
        let secondaryButtonTitle: String?
        let hasPrivacyPolicy: Bool

        init(mainIconName: String,
             topDescription: String? = nil,
             topDescriptionIconName: String? = nil,
             bottomDescription: String? = nil,
             bottomDescriptionFontSize: CGFloat = 20,
             primaryButtonTitle: String? = nil,
             secondaryButtonTitle: String? = nil,
             hasPrivacyPolicy: Bool = false) {
            self.mainIconName = mainIconName
            self.topDescription = topDescription
            self.topDescriptionIconName = topDescriptionIconName
            self.bottomDescription = bottomDescription
            self.bottomDescriptionFontSize = bottomDescriptionFontSize
            self.primaryButtonTitle = primaryButtonTitle
            self.secondaryButtonTitle = secondaryButtonTitle
            self.hasPrivacyPolicy = hasPrivacyPolicy
        }
    }
}
