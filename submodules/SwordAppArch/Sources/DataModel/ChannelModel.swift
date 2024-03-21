//
//  ChatItemModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 20.12.22.
//

import UIKit

public struct MessageParticipant: Decodable, Hashable {
    let id: String
    let name: String
    let image: Data?

    init(id: String, name: String, image: Data?) {
        self.id = id
        self.name = name
        self.image = image
    }
}

class SwordMessage {
    let id: Int
    let lastMessage: String
    let date: Date
    let sender: MessageParticipant
    let isSeen: Bool // TODO: - Change to CurrentValueSubject
    var isMine: Bool

    init(id: Int, lastMessage: String, date: Date, sender: MessageParticipant, isSeen: Bool, isMine: Bool) {
        self.id = id
        self.lastMessage = lastMessage
        self.date = date
        self.sender = sender
        self.isSeen = isSeen
        self.isMine = isMine
    }
}

final class RequestMessage: SwordMessage {
    let participants: [MessageParticipant]
    let paymentId: Int
    let paymentMethodInfo: PaymentMethodTypeModel
    let paymentType: PaymentType
    let amount: Double
    
    init(id: Int,
         participants: [MessageParticipant],
         paymentId: Int,
         paymentMethodInfo: PaymentMethodTypeModel,
         paymentType: PaymentType,
         amount: Double,
         lastMessage: String,
         date: Date,
         sender: MessageParticipant,
         isSeen: Bool,
         isMine: Bool) {
        self.participants = participants
        self.paymentId = paymentId
        self.paymentMethodInfo = paymentMethodInfo
        self.paymentType = paymentType
        self.amount = amount
        
        super.init(id: id, lastMessage: lastMessage, date: date, sender: sender, isSeen: isSeen, isMine: isMine)
    }
    
    enum CodingKeys: String, CodingKey {
        case participants
        case paymentMethodType
        case amount = "additional_price"
    }
}

public struct ChannelItemModel: Codable {
    let id: Int
    let date: String
    var lastMessage: ChannelMessageModel?
    let channelImage: String?
    let channelName: String?
    var users: [ChannelUserModel]
    
    var presentableName: String? {
        lazy var userName: String? = {
            guard let user = users.first(where: { $0.id != AppData.currentUserInfo?.id}) else { return nil }
            
            return "\(user.firstName) \(user.lastName)"
        }()
        
        return channelName ?? userName
    }
    
    var presentableChannelImagePath: String? {
        lazy var userAvatarPath: String? = {
            guard users.count == 2,
                  let user = users.first(where: { $0.id != AppData.currentUserInfo?.id}) else { return nil }
            
            return user.avatar
        }()
        
        return channelImage ?? userAvatarPath
    }

    var membersAdditionalInfo: String? {
        var firstTwoUsers = users.filter{ $0.id != AppData.currentUserInfo?.id }.prefix(3).map { $0.fullName }.joined(separator: ", ")
    
        let remainingUsersCount = users.count - 3
        
        if remainingUsersCount > 0 {
            let suffix = remainingUsersCount == 1 ? "" : "s"
            firstTwoUsers.append(" and \(remainingUsersCount) more participant\(suffix)")
        }
        
        return firstTwoUsers
    }

    var isPublicChannel: Bool { return false }
    var isSeen: Bool { return true } // TODO: - Change to CurrentValueSubject

    var isGroupChat: Bool {
        return users.count > 2
    }
    
    var isLastMessageMine: Bool {
        guard let lastMessage,
              let myUserName = AppData.currentUserInfo?.username else { return false }
        
        return lastMessage.sender.username == myUserName
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case channelName = "name"
        case date = "createdAt"
        case lastMessage
        case channelImage
        case users
    }
}

extension ChannelItemModel {    
    struct Message: Codable {
        let id: Int
        let date: String
        let message: String
        let sender: ChannelUserModel

        enum CodingKeys: String, CodingKey {
            case id
            case date = "createdAt"
            case message
            case sender
        }
    }
}
