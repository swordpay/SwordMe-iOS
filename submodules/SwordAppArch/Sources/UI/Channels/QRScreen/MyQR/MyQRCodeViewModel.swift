//
//  MyQRCodeViewModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 09.02.23.
//

import UIKit
import Combine

public struct MyQRCodeViewModelInputs {
    let downloadManager: DataDownloadManaging
}

public final class MyQRCodeViewModel: BaseViewModel<MyQRCodeViewModelInputs>, StackViewModeling {
    public var setupModel: CurrentValueSubject<MyQRStackViewModel?, Never>
    let username: String?
    let qrCodeSharePublisher: PassthroughSubject<UIImage, Never> = PassthroughSubject()
    let qrCodePrintPublisher: PassthroughSubject<UIImage, Never> = PassthroughSubject()

    lazy var shareButtonViewModel: GradientedButtonModel = {
        return GradientedButtonModel(title: Constants.Localization.Common.share,
                                     hasBorders: false,
                                     isActive: true,
                                     action: { [ weak self ] in
            guard let self,
                  let imageData = self.setupModel.value?.qrCodeImage.value,
                  let image = UIImage(data: imageData) else { return }

            self.qrCodeSharePublisher.send(image)
        })
    }()
    
    lazy var printButtonViewModel: GradientedButtonModel = {
        return GradientedButtonModel(title: Constants.Localization.Common.print,
                                     hasBorders: true,
                                     isActive: true,
                                     action: { [ weak self ] in
            guard let self,
                  let imageData = self.setupModel.value?.qrCodeImage.value,
                  let image = UIImage(data: imageData) else { return }

            self.qrCodePrintPublisher.send(image)
        })
    }()
    
    init(inputs: MyQRCodeViewModelInputs, username: String?) {
        self.username = username
        
        self.setupModel = .init(.init(username: username))
        super.init(inputs: inputs)
    }
}
