//
//  Constants+AppDataKey.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 19.04.22.
//

import Foundation

extension Constants {
    enum AppDataKey: String {
        case currentUserInfo = "current_user_info"
        case isInComplianceMode = "is_in_compliance_mode"
        case onboardingUser = "onboarding_user"
        case cardToOrder = "card_to_order"
        case isBiometricAuthenticationEnabled = "is_biometric_authentication_enabled"
        case boughtEventId = "bought_event_id"
        case isFirstLaunch = "is_first_launch"
        case appVersion = "app_versio"
        case pushNotificationUserInfo = "pushNotificationUserInfo"
        case deepLinkURL = "deepLinkURL"
        case isRegistredUserExists = "isRegistredUserExists"
        case payOrRequestStateInfo = "payOrRequestStateInfo"
        case needIntergiroPrivicyPolicy = "needIntergiroPrivicyPolicy"
        case wasOnboardinScreenPresented = "wasOnboardinScreenPresented"
        case userAvatarData = "userAvatarData"
        case userPhoneNumber = "userPhoneNumber"
        case userTelegramPeerId = "userTelegramPeerId"
        case userTelegramExtraPeerId = "userTelegramExtraPeerId"
        case telegramUserUsername = "telegramUserUsername"
        case isTFAEnabled = "isTFAEnabled"
        case hasChatFolders = "hasChatFolders"
        case isChannelAdmin = "isChannelAdmin"
        case isAppAcitve = "isAppAcitve"
        case accessToken = "accessToken"
    }
}
