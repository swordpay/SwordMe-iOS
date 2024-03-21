//
//  ChannelMessageModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 31.03.23.
//

import Foundation

public struct ChannelMessageModel: Codable {
    var id: Int?
    let date: String
    let text: String
    let sender: ChannelUserModel
    let payment: Payment?
    let paymentTransaction: PaymentTransaction?
    var isDeleted: Bool?
    let referenceId: String?
    
    var isMine: Bool {
        return sender.username == AppData.currentUserInfo?.username
    }
    
    var content: String {
        var text: String

        if let payment = payment {
            if let paymentTransaction = paymentTransaction {
                if payment.paymentType == .request {
                    if paymentTransaction.status == .completed,
                       let amount = paymentTransaction.amount,
                       let currency = paymentTransaction.currency {
                        text = Constants.Localization.Channels.channelItemPaid(amountInfo: "\(amount.bringToPresentableFormat()) \(currency)")
                    } else {
                        text = Constants.Localization.Channels.channelItemRejected(sender: payment.creator.fullName)
                    }
                } else {
                    text = Constants.Localization.Channels.channelItemPaid(amountInfo: "\(payment.amount.formattedDecimalNumber()?.bringToPresentableFormat() ?? payment.amount) \(payment.currencyType)")
                }
            } else {
                text = Constants.Localization.Channels.channelItemRequested(amountInfo: "\(payment.amount.formattedDecimalNumber()?.bringToPresentableFormat() ?? payment.amount) \(payment.currencyType)")
            }
        } else {
            text = self.text
        }
        
        return text
    }

    enum CodingKeys: String, CodingKey {
        case id
        case date = "createdAt"
        case text = "message"
        case sender
        case payment
        case paymentTransaction
        case isDeleted
        case referenceId
    }
}

extension ChannelMessageModel {
    public struct Payment: Codable {
        let id: Int?
        let amount: String
        let currencyType: String
        let paymentMethodType: PaymentMethodType
        let paymentType: PaymentType
        let creator: ChannelUserModel
        
        enum CodingKeys: String, CodingKey {
            case id
            case amount
            case currencyType
            case paymentMethodType = "transactionType"
            case paymentType = "type"
            case creator
        }
    }
    
    public struct PaymentTransaction: Codable {
        let status: Status
        let amount: Double?
        let currency: String?
        let note: String?
        let user: PaymentUserModel
    }
    
    public enum Status: String, Codable {
        case rejected
        case completed
        case pending
    }
}

public extension ChannelMessageModel {
    static var dummyMessage: ChannelMessageModel {
        let userModel = ChannelUserModel(id: "14", firstName: "Tigran", lastName: "Simonyan", username: "tigsim", avatar: nil)
        let payment = Payment(id: 20, amount: "10.5", currencyType: "EUR", paymentMethodType: .fiat, paymentType: .request, creator: userModel)
        
        return .init(date: "", text: "Transaction", sender: .init(id: "1", firstName: "Tigran", lastName: "Simonyan", username: "tigsim", avatar: nil), payment: payment, paymentTransaction: nil, referenceId: nil)
    }
}
