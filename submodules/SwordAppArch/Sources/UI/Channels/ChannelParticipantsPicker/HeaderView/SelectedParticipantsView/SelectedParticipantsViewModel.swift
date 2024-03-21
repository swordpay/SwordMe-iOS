//
//  SelectedParticipantsViewModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 21.04.23.
//

import Combine
import Foundation

final class SelectedParticipantsViewModel {
    private var cancellables: Set<AnyCancellable> = []

    let downloadManager: DataDownloadManaging
    let selectedParticipants: CurrentValueSubject<[Constants.Typealias.PeerExtendedInfo], Never>
    
    let deletedParticipantPublisher: PassthroughSubject<Constants.Typealias.PeerExtendedInfo, Never> = PassthroughSubject()
    
    init(selectedParticipants: [Constants.Typealias.PeerExtendedInfo],
         downloadManager: DataDownloadManaging) {
        self.selectedParticipants = .init(selectedParticipants)
        self.downloadManager = downloadManager
    }
    
    func deleteParticipan(at indexPath: IndexPath) {
        guard let deletedParticipant = selectedParticipants.value[safe: indexPath.item] else { return }
        
        deletedParticipantPublisher.send(deletedParticipant)
    }
}
