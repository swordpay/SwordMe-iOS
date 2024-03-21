//
//  ChannelRequestDetailsItemCell.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 28.12.22.
//

import UIKit

final class ChannelRequestDetailsItemCell: SetupableTableViewCell {
   
    // MARK: - IBOutlets
    
    @IBOutlet private weak var participantNameLabel: UILabel!
    @IBOutlet private weak var paidAmountLabel: UILabel!
    @IBOutlet private weak var paymentDateLabel: UILabel!
    
    // MARK: - Properties
    
    private var model: ChannelRequestDetailsItemCellModel!
    
    // MARK: - Setup UI
    
    func setup(with model: ChannelRequestDetailsItemCellModel) {
        self.model = model
        
        selectionStyle = .none

        let paymentInfo = model.paymentInfo
        
        participantNameLabel.text = paymentInfo.sender.name
        paymentDateLabel.text = paymentInfo.date.toCommonFormattedDate()
        paidAmountLabel.text = model.paymentAmountText
    }
}
