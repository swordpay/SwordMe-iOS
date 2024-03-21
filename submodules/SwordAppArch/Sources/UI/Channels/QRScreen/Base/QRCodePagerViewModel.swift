//
//  QRCodePagerViewModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 09.02.23.
//

import Combine
import Foundation

final class QRCodePagerViewModel: BaseViewModel<Void>, StackViewModeling {
    var setupModel: CurrentValueSubject<QRCodePagerStackViewModel?, Never>
    
    init(scanResultPublisher: PassthroughSubject<String?, Never>) {
        self.setupModel = .init(.init(scanResultPublisher: scanResultPublisher))
        
        super.init(inputs: ())
    }
}
