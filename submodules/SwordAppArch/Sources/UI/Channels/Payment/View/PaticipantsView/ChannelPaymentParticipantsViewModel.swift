//
//  ChannelPaymentParticipantsViewModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 22.05.23.
//

import Combine
import Foundation
import TelegramCore

final class ChannelPaymentParticipantsViewModel {
    let title: String?
    var participants: CurrentValueSubject<[ChannelsHeaderViewModel.Info], Never>
    
    let moreButtonTapHandler: PassthroughSubject<Void, Never> = PassthroughSubject()
    let addMoreParticipantsButtonTapHandler: PassthroughSubject<Void, Never> = PassthroughSubject()
    
    init(title: String?, participants: [ChannelsHeaderViewModel.Info]) {
        self.title = title
        self.participants = .init(participants)
    }
}
