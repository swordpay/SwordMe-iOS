//
//  GetPaymentInfoResponse.swift
//  SwordAppArch
//
//  Created by Tigran Simonyan on 24.08.23.
//

import Foundation

public struct GetPaymentInfoResponse: Codable {
    let id: Int
    let amount: String
    let currencyType: String
    let messageId: Int
    let transactionType: PaymentMethodType
    let type: PaymentType
    let note: String?
    let creator: PaymentUserModel
    var paymentTransaction: ChannelMessageModel.PaymentTransaction?
    let telegramPeer: TelegramPeer
}
