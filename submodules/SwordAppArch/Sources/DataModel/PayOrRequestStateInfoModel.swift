//
//  PayOrRequestStateInfoModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 07.04.23.
//

import Postbox
import Foundation
import TelegramCore

public struct PayOrRequestStateInfoModel: Codable {
    var peerId: PeerId?
    var source: ChannelPaymentViewModel.Source
    var redirectingSource: ChannelPaymentViewModel.RedirectingSource?
    var isRequesting: Bool
    var channelInfo: ChannelItemModel?
    var requestInfo: DecodableMessage?
    var paymentId: String?
    var messageId: Int32?
    var isSendActionAvailable: Bool
    
    public init(peerId: PeerId?,
                source: ChannelPaymentViewModel.Source,
                redirectingSource: ChannelPaymentViewModel.RedirectingSource? = nil,
                isRequesting: Bool,
                channelInfo: ChannelItemModel? = nil,
                requestInfo: DecodableMessage? = nil,
                paymentId: String? = nil,
                messageId: Int32? = nil,
                isSendActionAvailable: Bool = false) {
        self.peerId = peerId
        self.source = source
        self.redirectingSource = redirectingSource
        self.isRequesting = isRequesting
        self.channelInfo = channelInfo
        self.requestInfo = requestInfo
        self.paymentId = paymentId
        self.messageId = messageId
        self.isSendActionAvailable = isSendActionAvailable
    }
}
