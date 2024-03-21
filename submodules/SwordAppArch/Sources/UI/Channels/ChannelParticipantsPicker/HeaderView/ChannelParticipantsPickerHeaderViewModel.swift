//
//  ChannelParticipantsPickerHeaderViewModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 27.03.23.
//

import Combine
import Foundation

final class ChannelParticipantsPickerHeaderViewModel {
    let source: ChannelParticipantsPickerSource
    let searchBarSetupModel: SearchBarHeaderViewModel
    let initialPeers: [Constants.Typealias.PeerExtendedInfo]
    let dataSource: CurrentValueSubject<[SelectedParticipantItemCellModel], Never>
    let addingParticipant: PassthroughSubject<Constants.Typealias.PeerExtendedInfo, Never> = PassthroughSubject()
    let deletingParticipantIndexPath: PassthroughSubject<IndexPath, Never> = PassthroughSubject()
    
    let deletedParticipantPublisher: PassthroughSubject<Constants.Typealias.PeerExtendedInfo, Never> = PassthroughSubject()
    let doneButtonTouchHandler: PassthroughSubject<Void, Never> = PassthroughSubject()
    
//    var groupName: CurrentValueSubject<String?, Never> = .init(nil)

    init(source: ChannelParticipantsPickerSource,
         searchBarSetupModel: SearchBarHeaderViewModel, initialPeers: [Constants.Typealias.PeerExtendedInfo]) {
        self.source = source
        self.searchBarSetupModel = searchBarSetupModel
        self.initialPeers = initialPeers
        self.dataSource = .init(initialPeers.map {SelectedParticipantItemCellModel(participant: $0)})
    }
    
    func deleteParticipant(_ participant: Constants.Typealias.PeerExtendedInfo) {
        guard let firstIndex = dataSource.value.firstIndex(where: { $0.participant.enginePeer.id == participant.enginePeer.id }) else { return }

        let participant = dataSource.value.remove(at: firstIndex).participant

        deletedParticipantPublisher.send(participant)
        deletingParticipantIndexPath.send(IndexPath(item: firstIndex, section: 0))
    }
}
