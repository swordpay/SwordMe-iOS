//
//  CryptoAccountSection.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 10.02.23.
//

import Foundation

public final class CryptoAccountSection: Sectioning {
    public typealias HeaderModel = TitledTableHeaderAndFooterViewModel
    public typealias CellModel = CryptoItemCellModel
    public typealias FooterModel = EmptyModel
    
    public var headerModel: TitledTableHeaderAndFooterViewModel
    public var cellModels: [CryptoItemCellModel]
    public var footerModel: EmptyModel = EmptyModel()

    public init(headerModel: TitledTableHeaderAndFooterViewModel,
         cellModels: [CryptoItemCellModel]) {
        self.headerModel = headerModel
        self.cellModels = cellModels
    }
}
