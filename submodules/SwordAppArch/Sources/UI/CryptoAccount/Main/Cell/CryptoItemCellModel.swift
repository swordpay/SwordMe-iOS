//
//  CryptoItemCellModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 10.02.23.
//

import UIKit
import Combine

public final class CryptoItemCellModel {
    private let downloadManager: DataDownloadManaging
    private var cancellables: Set<AnyCancellable> = []
    
    var cachedImage: Data?

    let cryptoModel: CryptoModel
    let cryptoIconDataPublisher: CurrentValueSubject<Data?, Never> = CurrentValueSubject(nil)

    var defaultIconData: Data? = {
        return UIImage(imageName: Constants.AssetName.CryptoAccount.cryptoIconPlaceholder)?.jpegData(compressionQuality: 1)
    }()
    
    var cryptoInfo: String {
        guard let balance = cryptoModel.accountInfo?.balance.value.bringToPresentableFormat(maximumFractionDigits: Constants.cryptoDefaultPrecision) else {
            return cryptoModel.abbreviation
        }
        
        return "\(balance)"
    }
    
    var priceInEuro: String {
        let presentableFormat = cryptoModel.priceInEuro.value.bringToPresentableFormat()

        return "€ \(presentableFormat)"
    }

    init(cryptoModel: CryptoModel, downloadManager: DataDownloadManaging) {
        self.cryptoModel = cryptoModel
        self.downloadManager = downloadManager
    }
    
    func prepareCryptoImageData() {
        guard cachedImage == nil else {
            cryptoIconDataPublisher.send(cachedImage)
            
            return
        }

        guard let iconURL = URL(string: cryptoModel.iconPath) else {
            print("no icon url \(cryptoModel.abbreviation) , url - \(cryptoModel.iconPath)")
            cryptoIconDataPublisher.send(defaultIconData)
            
            return
        }
        
        downloadManager.download(from: iconURL)
            .sink { [ weak self ] completion in

                switch completion {
                case .failure(_):
                    print("crypto faield icons url \(iconURL.absoluteString)")
                    self?.cryptoIconDataPublisher.send(self?.defaultIconData)
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
