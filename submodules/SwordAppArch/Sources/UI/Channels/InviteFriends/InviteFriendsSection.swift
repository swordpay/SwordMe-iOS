//
//  InviteFriendsSection.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 08.02.23.
//

import Foundation

final class InviteFriendsSection: Sectioning {
    typealias HeaderModel = TitledTableHeaderAndFooterViewModel
    typealias CellModel = InviteFriendsParticipantItemCellModel
    typealias FooterModel = EmptyModel
    
    var headerModel: TitledTableHeaderAndFooterViewModel
    var cellModels: [InviteFriendsParticipantItemCellModel]
    var footerModel: EmptyModel = EmptyModel()
    
    internal init(headerModel: TitledTableHeaderAndFooterViewModel,
                  cellModels: [InviteFriendsParticipantItemCellModel]) {
        self.headerModel = headerModel
        self.cellModels = cellModels
    }
}
