//
//  MyQRStackViewModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 09.02.23.
//

import Combine
import Foundation

public final class MyQRStackViewModel {
    let user: UserModel?
    let qrCodeImage: CurrentValueSubject<Data?, Never> = CurrentValueSubject(nil)

    let username: String?
    let actionPublisher: PassthroughSubject<Action, Never> = PassthroughSubject()
    init(user: UserModel? = AppData.currentUserInfo, username: String?) {
        self.user = user
        self.username = username
    }
}

extension MyQRStackViewModel {
    public enum Action {
        case print
        case share
        case sendViaEmail
    }
}
