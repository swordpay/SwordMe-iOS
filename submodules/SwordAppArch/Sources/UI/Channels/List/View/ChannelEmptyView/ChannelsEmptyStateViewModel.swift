//
//  ChannelsEmptyStateViewModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 20.12.22.
//

import Combine
import Foundation

public final class ChannelsEmptyStateViewModel {
    public let syncContactsPublisher: PassthroughSubject<Void, Never> = PassthroughSubject()
    public let inviteFriendsPublisher: PassthroughSubject<Void, Never> = PassthroughSubject()
}
