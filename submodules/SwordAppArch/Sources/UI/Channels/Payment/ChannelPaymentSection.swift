//
//  ChannelPaymentSection.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 26.12.22.
//

import Foundation

final class ChannelPaymentSection: Sectioning {
    typealias HeaderModel = ChannelPaymentSectionHeaderViewModel
    typealias CellModel = ChannelParticipantsPickerCellModel
    typealias FooterModel = EmptyModel
    
    var headerModel: ChannelPaymentSectionHeaderViewModel
    var cellModels: [ChannelParticipantsPickerCellModel]
    var footerModel: EmptyModel = EmptyModel()

    init(headerModel: ChannelPaymentSectionHeaderViewModel,
         cellModels: [ChannelParticipantsPickerCellModel]) {
        self.headerModel = headerModel
        self.cellModels = cellModels
    }
}
