//
//  Notification+Name.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 27.02.23.
//

import Foundation

extension Notification.Name {
    public static let chatScreenDidDismiss = Notification.Name("chatScreenDidDismiss")
    public static let channelsInfoDidChange = Notification.Name("channelsInfoDidChange")
    public static let accountInfoDidChange = Notification.Name("accountInfoDidChange")
    public static let cryptoAccountInfoDidChange = Notification.Name("cryptoAccountInfoDidChange")
    public static let payOrRequestDidComplete = Notification.Name("payOrRequestDidComplete")
    public static let declinePayment = Notification.Name("declinePayment")
    public static let acceptPayment = Notification.Name("acceptPayment")
    public static let usernameDidSelected = Notification.Name("usernameDidSelected")
    public static let recentItemDidSelected = Notification.Name("recentItemDidSelected")
    public static let chatsTransactionsDidTap = Notification.Name("chatsTransactionsDidTap")
    public static let topUpDidPressed = Notification.Name("topUpDidPressed")
    public static let launchScreenDidHide = Notification.Name("launchScreenDidHide")
    public static let authenticationCodeDidReceived = Notification.Name("authenticationCodeDidReceived")
    public static let cryptoAccuntStatusUpdateShouldUpdated = Notification.Name("cryptoAccuntStatusUpdateShouldUpdated")
    public static let appLogout = Notification.Name("appLogout")
    public static let authorizationDidCompleted = Notification.Name("authorizationDidCompleted")
    public static let documentPreviewerDidPresented = Notification.Name("documentPreviewerDidPresented")
    public static let documentPreviewerDidPDismissed = Notification.Name("authorizationDidCompleted")
}
