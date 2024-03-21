//
//  ViewControllerProvider+CryptoAccount.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 20.12.22.
//

import Combine
import Swinject
import Foundation
import AccountContext

public extension ViewControllerProvider {
    enum CryptoAccount {
        public static func cryptoAccount(context: AccountContext) -> CryptoAccountViewController {
            let assembler = Assembler([
                DataCacherAssembly(),
                URLSessionDataDownloaderAssembly(),
                DataDownloadManagerAssembly(),
                GetCryptoBalanceServiceAssembly(),
                GetCryptoAssetsServiceAssembly(),
                AssetsPricesChangesServiceAssembly(),
                GetAssetItemInfoServiceAssembly(),
                CryptoAccountViewControllerAssembly(context: context)])
            let controller = assembler.resolver.resolve(CryptoAccountViewController.self)!

            return controller
        }
        
        static func cryptoPicker(coins: [CryptoPickerItemCellModel.CoinInfo],
                                 selectedCrypto: CurrentValueSubject<CryptoPickerItemCellModel.CoinInfo?, Never>) -> CryptoPickerViewController {
            let assembler = Assembler([
                GetCryptoAssetsServiceAssembly(),
                CryptoPickerViewControllerAssembly(coins: coins,
                                                   selectedCrypto: selectedCrypto)])
            let controller = assembler.resolver.resolve(CryptoPickerViewController.self)!

            return controller
        }
        
        static func cryptoDetails(allCryptos: GetCryptoAssetsResponse,
                                  cryptoInfo: CryptoModel,
                                  mainCoinInfo: AppMainCoinInfo) -> CryptoDetailsViewController {
            let assembler = Assembler([ GetCryptoChartDataServiceAssembly(),
                                        GetAssetItemInfoServiceAssembly(),
                                        CryptoDetailsViewControllerAssembly(allCryptos: allCryptos,
                                                                            cryptoInfo: cryptoInfo,
                                                                            mainCoinInfo: mainCoinInfo) ])
            let controller = assembler.resolver.resolve(CryptoDetailsViewController.self)!
            controller.hidesBottomBarWhenPushed = true

            return controller
        }
        
        static func buyOrSellCrypto(cryptoActionModel: CryptoActionModel) -> BuyOrSellCryptoViewController {
            let assembler = Assembler([ BuyCryptoServiceAssembly(),
                                        SellCryptoServiceAssembly(),
                                        CryptoTradeInfoServiceAssembly(),
                                        BuyOrSellCryptoViewControllerAssembly(cryptoActionModel: cryptoActionModel) ])
            let controller = assembler.resolver.resolve(BuyOrSellCryptoViewController.self)!

            return controller
        }
    }
}
