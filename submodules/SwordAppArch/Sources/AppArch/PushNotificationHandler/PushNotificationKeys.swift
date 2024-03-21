//
//  PushNotificationKeys.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 24.02.23.
//

import Foundation

enum PushNotificationKeys: String {
    case messages = "TEXT_MESSAGE"
    case PAYMENT_GROUP_REQUEST_CREATED
    case PAYMENT_DM_REQUEST_CREATED // +
    case PAYMENT_GROUP_RECEIVED
    case PAYMENT_DM_RECEIVED
    case PAYMENT_GROUP_ACCEPTED
    case PAYMENT_DM_ACCEPTED // +
    case PAYMENT_GROUP_REJECTED
    case PAYMENT_DM_REJECTED // +
}
