//
//  ChannelRequestDetailsSection.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 28.12.22.
//

import Foundation

final class ChannelRequestDetailsSection: Sectioning {
    
    typealias HeaderModel = ChannelRequestDetailsSectionHeaderViewModel
    typealias CellModel = ChannelRequestDetailsItemCellModel
    typealias FooterModel = EmptyModel
    
    var headerModel: ChannelRequestDetailsSectionHeaderViewModel
    var cellModels: [ChannelRequestDetailsItemCellModel]
    var footerModel: EmptyModel = EmptyModel()

    init(headerModel: ChannelRequestDetailsSectionHeaderViewModel,
         cellModels: [ChannelRequestDetailsItemCellModel]) {
        self.headerModel = headerModel
        self.cellModels = cellModels
    }
}
