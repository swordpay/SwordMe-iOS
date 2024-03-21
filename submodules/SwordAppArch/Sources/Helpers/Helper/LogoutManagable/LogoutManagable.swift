//
//  LogoutManagable.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 12.07.22.
//

import UIKit

public protocol LogoutManagable {
    func logout()
    func dumpUserInfo()
}

extension LogoutManagable {
    public func logout() {
        dumpUserInfo()
        NotificationCenter.default.post(name: .appLogout, object: self)
    }
    
    public func dumpUserInfo() {
        AppData.currentUserInfo = nil
        AppData.telegramUserUsername = nil
        AppData.userAvatarData = nil
        AppData.isRegistredUserExists = false
        SocketIOSocketManager.global.disconect()
        WebSocketManager.global.disconect()
    }
}
