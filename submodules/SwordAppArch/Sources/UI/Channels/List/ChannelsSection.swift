//
//  ChannelsSection.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 20.12.22.
//

import Foundation

final class ChannelsSection: Sectioning {
    typealias HeaderModel = EmptyModel
    typealias CellModel = ChannelItemCellModel
    typealias FooterModel = EmptyModel
    
    var headerModel: EmptyModel = EmptyModel()
    var cellModels: [ChannelItemCellModel]
    var footerModel: EmptyModel = EmptyModel()

    init(cellModels: [ChannelItemCellModel]) {
        self.cellModels = cellModels
    }
}
