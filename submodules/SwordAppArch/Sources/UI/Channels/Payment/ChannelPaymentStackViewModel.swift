//
//  ChannelPaymentStackViewModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 29.03.23.
//

import Combine
import Foundation

public final class ChannelPaymentStackViewModel {
    var downloadManager: DataDownloadManaging
    var channelInfo: ChannelItemModel?
    var amounts: CurrentValueSubject<Amount, Never>
    
    let headerModel: ChannelPaymentHeaderViewModel
    let footerModel: ChannelPaymentFooterViewModel

    init(channelInfo: ChannelItemModel?,
         amounts: Amount,
         headerModel: ChannelPaymentHeaderViewModel,
         footerModel: ChannelPaymentFooterViewModel,
         downloadManager: DataDownloadManaging) {
        self.channelInfo = channelInfo
        self.headerModel = headerModel
        self.footerModel = footerModel
        self.amounts = .init(amounts)
        self.downloadManager = downloadManager
    }
}

public extension ChannelPaymentStackViewModel {
    struct Amount {
        var available: String?
        var min: String
        var max: String
    }
}
