//
//  ChannelParticipantsListViewModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 22.05.23.
//

import Combine
import Foundation

final class ChannelParticipantsListViewModel: BaseViewModel<Void>, DataSourced {
    var dataSource: CurrentValueSubject<[ChannelParticipantsListSection], Never> = .init([])
    
    var addedRowsInfo: TableViewUpdatingDataModel = .init(status: .insert)
    var deletedRowsInfo: TableViewUpdatingDataModel = .init(status: .deleted)
    
    let participants: [Constants.Typealias.PeerExtendedInfo]
    
    init(participants: [Constants.Typealias.PeerExtendedInfo]) {
        self.participants = participants
        
        super.init(inputs: ())
    }
    
    func provideDataSource() {
        let cellModels = participants.map { ChannelParticipantsListItemCellModel(user: $0) }
        let section = ChannelParticipantsListSection(cellModels: cellModels)
        
        dataSource.send([section])
    }
}
