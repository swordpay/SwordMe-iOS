//
//  PushNotificationHandlerProvider.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 24.02.23.
//

import Foundation

final class PushNotificationHandlerProvider {
    static func handler(for key: PushNotificationKeys, data: [AnyHashable: Any]?) -> PushNotificationHandling {
        switch key {
        case .messages,
                .PAYMENT_GROUP_REQUEST_CREATED,
                .PAYMENT_DM_REQUEST_CREATED,
                .PAYMENT_GROUP_RECEIVED,
                .PAYMENT_DM_RECEIVED,
                .PAYMENT_GROUP_ACCEPTED,
                .PAYMENT_DM_ACCEPTED,
                .PAYMENT_GROUP_REJECTED,
                .PAYMENT_DM_REJECTED:
            return MessagesPushNotificationHandler(userInfo: data)
        }
    }
}
