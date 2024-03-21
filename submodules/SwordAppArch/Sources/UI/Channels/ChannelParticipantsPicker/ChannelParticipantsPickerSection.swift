//
//  ChannelParticipantsPickerSection.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 21.12.22.
//

import Foundation

final class ChannelParticipantsPickerSection: Sectioning {
    typealias HeaderModel = TitledTableHeaderAndFooterViewModel
    typealias CellModel = ChannelParticipantsPickerCellModel
    typealias FooterModel = EmptyModel
    
    var headerModel: TitledTableHeaderAndFooterViewModel
    var cellModels: [ChannelParticipantsPickerCellModel]
    var footerModel: EmptyModel = EmptyModel()
    
    internal init(headerModel: TitledTableHeaderAndFooterViewModel,
                  cellModels: [ChannelParticipantsPickerCellModel]) {
        self.headerModel = headerModel
        self.cellModels = cellModels
    }
}
