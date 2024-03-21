//
//  CryptoInfoItemViewModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 10.02.23.
//

import UIKit
import Combine

final class CryptoInfoItemViewModel {
    private var cancellables: Set<AnyCancellable> = []
    private let downloadManager: DataDownloadManaging = DataDownloadManagerProvider.default

    let cryptoModel: CryptoModel
    let hasSeparator: Bool
    let cryptoIconDataPublisher: PassthroughSubject<Data?, Never> = PassthroughSubject()

    init(cryptoModel: CryptoModel, hasSeparator: Bool) {
        self.cryptoModel = cryptoModel
        self.hasSeparator = hasSeparator
    }
    
    func prepareCryptoImageData() {
        guard let iconURL = URL(string: cryptoModel.iconPath) else {
            cryptoIconDataPublisher.send(nil)
            
            return
        }

        downloadManager.download(from: iconURL)
            .sink { [ weak self ] completion in
                switch completion {
                case .failure(_):
                    self?.cryptoIconDataPublisher.send(nil)
                default:
                    return
                }
            } receiveValue: { [ weak self ] data in
                self?.cryptoIconDataPublisher.send(data)
            }
            .store(in: &cancellables)
    }
        
    func cancelPaymentMethodIconDownloading() {
        guard let iconURL = URL(string: cryptoModel.iconPath) else { return }

        downloadManager.cancelDownloading(for: iconURL)
    }
}
