//
//  SelectedParticipantItemCellModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 21.04.23.
//

import Combine
import Foundation
import Kingfisher

final class SelectedParticipantItemCellModel {
    private var cancellables: Set<AnyCancellable> = []

    static let cellIdentifier = "\(SelectedParticipantItemCellModel.self)"
    
    let participant: Constants.Typealias.PeerExtendedInfo
    let deleteUserButtonPublisher: PassthroughSubject<Void, Never> = PassthroughSubject()
    var isSelected: Bool = false

    init(participant: Constants.Typealias.PeerExtendedInfo) {
        self.participant = participant
    }
}
