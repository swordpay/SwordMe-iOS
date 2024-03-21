//
//  CryptoPickerSection.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 09.03.23.
//

import Foundation

final class CryptoPickerSection: Sectioning {
    typealias HeaderModel = TitledTableHeaderAndFooterViewModel
    typealias CellModel = CryptoPickerItemCellModel
    typealias FooterModel = EmptyModel
    
    var headerModel: TitledTableHeaderAndFooterViewModel
    var cellModels: [CryptoPickerItemCellModel]
    var footerModel: EmptyModel = EmptyModel()

    init(headerModel: TitledTableHeaderAndFooterViewModel,
         cellModels: [CryptoPickerItemCellModel]) {
        self.headerModel = headerModel
        self.cellModels = cellModels
    }
}
