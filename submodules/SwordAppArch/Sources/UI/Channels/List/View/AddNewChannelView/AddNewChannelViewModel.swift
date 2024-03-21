//
//  AddNewChannelViewModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 21.12.22.
//

import Combine
import Foundation

final class AddNewChannelViewModel {
    let directMessageButtonPublisher: PassthroughSubject<Void, Never> = PassthroughSubject()
    let groupChannelButtonPublisher: PassthroughSubject<Void, Never> = PassthroughSubject()
}
