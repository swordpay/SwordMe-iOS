//
//  QRScannerViewModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 08.02.23.
//

import Combine
import Foundation

final class QRScannerViewModel: BaseViewModel<Void>, StackViewModeling {
    var setupModel: CurrentValueSubject<QRScannerStackViewModel?, Never>
    
    var resultPublisher: PassthroughSubject<String?, Never>
    var emptyStateViewModel: SystemServicePermissionAccessViewModel = .init(systemService: .camera)
    
    let hasCloseButton: Bool
    init(hasCloseButton: Bool, resultPublisher: PassthroughSubject<String?, Never>) {
        self.resultPublisher = resultPublisher
        self.hasCloseButton = hasCloseButton

        self.setupModel = .init(.init(hasCloseButton: hasCloseButton))

        super.init(inputs: ())
    }
}
