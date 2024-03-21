//
//  CryptoPickerItemCellModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 22.03.23.
//

import UIKit
import Combine

final class CryptoPickerItemCellModel {
    private var cancellables: Set<AnyCancellable> = []

    let cryptoMainInfo: CoinInfo
    let cryptoIconDataPublisher: CurrentValueSubject<Data?, Never> = CurrentValueSubject(nil)
   
    var defaultIconData: Data? = {
        return UIImage(imageName: Constants.AssetName.CryptoAccount.cryptoIconPlaceholder)?.jpegData(compressionQuality: 1)
    }()

    var info: String {
        guard let balance = cryptoMainInfo.balance else {
            return cryptoMainInfo.abbriviation
        }
        
        return balance.bringToPresentableFormat()
    }

    var iconURL: URL? {
        guard let iconPath = cryptoMainInfo.iconPath,
              let url = URL(string: iconPath) else { return nil }
        
        return url
    }
    
    init(cryptoMainInfo: CoinInfo) {
        self.cryptoMainInfo = cryptoMainInfo
    }
}

extension CryptoPickerItemCellModel {
    struct CoinInfo {
        let name: String
        let abbriviation: String
        let iconPath: String?
        var balance: Double?
    }
}
