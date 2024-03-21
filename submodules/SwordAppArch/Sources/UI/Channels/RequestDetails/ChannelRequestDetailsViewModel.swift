//
//  ChannelRequestDetailsViewModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 28.12.22.
//

import Combine
import Foundation

final class ChannelRequestDetailsViewModel: BaseViewModel<Void>, DataSourced {
    var dataSource: CurrentValueSubject<[ChannelRequestDetailsSection], Never> = CurrentValueSubject([])
    
    var addedRowsInfo: TableViewUpdatingDataModel = .init(status: .insert)
    var deletedRowsInfo: TableViewUpdatingDataModel = .init(status: .deleted)
    
    let requestDetails: PaymentRequestModel
    let isForRequestDetails: Bool
    let closeRequestCompletion: PassthroughSubject<(Int, String?), Never>

    lazy var commentViewModel: CommentBottomSheetViewModel = {
        return CommentBottomSheetViewModel(rightSideButtonTitle: Constants.Localization.Common.confirm,
                                                title: "You are about to close your request",
                                                description: "2 people paid per your request. After closing no one can send money to this request.")
    }()

    init(requestDetails: PaymentRequestModel,
         isForRequestDetails: Bool,
         closeRequestCompletion: PassthroughSubject<(Int, String?), Never>) {
        self.requestDetails = requestDetails
        self.isForRequestDetails = isForRequestDetails
        self.closeRequestCompletion = closeRequestCompletion

        super.init(inputs: ())
    }
    
    func provideDataSource() {
        guard isForRequestDetails else {
            dataSource.send([])
            
            return
        }

        let headerModel = ChannelRequestDetailsSectionHeaderViewModel(hasPayment: !requestDetails.paymentInfo.isEmpty)
        let cellModels = requestDetails.paymentInfo.map {ChannelRequestDetailsItemCellModel(paymentInfo: $0)}
        let section = ChannelRequestDetailsSection(headerModel: headerModel, cellModels: cellModels)
        
        dataSource.send([section])
    }
}
