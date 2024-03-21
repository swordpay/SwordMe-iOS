//
//  ChannelParticipantsListSection.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 22.05.23.
//

import Foundation

final class ChannelParticipantsListSection: Sectioning {
    
    typealias HeaderModel = EmptyModel
    typealias CellModel = ChannelParticipantsListItemCellModel
    typealias FooterModel = EmptyModel
    
    
    var headerModel: EmptyModel = EmptyModel()
    var cellModels: [ChannelParticipantsListItemCellModel]
    var footerModel: EmptyModel = EmptyModel()

    init(cellModels: [ChannelParticipantsListItemCellModel]) {
        self.cellModels = cellModels
    }
}
