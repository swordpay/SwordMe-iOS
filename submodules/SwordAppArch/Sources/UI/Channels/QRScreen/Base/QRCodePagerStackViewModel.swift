//
//  QRCodePagerStackViewModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 09.02.23.
//

import Combine
import Foundation

final class QRCodePagerStackViewModel {
    let closeButtonPublisher: PassthroughSubject<Void, Never> = PassthroughSubject()
    
    let scanResultPublisher: PassthroughSubject<String?, Never>

    var qrOptionSegmentedControlViewModel = SegmentedControlSetupModel(models: [
        .init(title: Constants.Localization.Common.scanCode,
              isSelected: CurrentValueSubject(true)),
        .init(title: Constants.Localization.Common.swordMe,
              isSelected: CurrentValueSubject(false))
    ])
    
    init(scanResultPublisher: PassthroughSubject<String?, Never>) {
        self.scanResultPublisher = scanResultPublisher
    }
}
