//
//  ChannelRequestDetailsHeaderViewModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 28.12.22.
//

import Foundation

final class ChannelRequestDetailsHeaderViewModel {
    private var defaultAttributes: [NSAttributedString.Key: Any] {
        let currentTheme = ThemeProvider.currentTheme

        return [.foregroundColor: currentTheme.colors.textColor,
                .font: currentTheme.fonts.bold(ofSize: 17, family: .rubik)]
    }
    
    let requestDetails: PaymentRequestModel
    
    init(requestDetails: PaymentRequestModel) {
        self.requestDetails = requestDetails
    }
    
    func provideDataSource() -> [(String, NSAttributedString)] {
        return [("Sent from", prepareRequestSenderAttributedName()),
                ("Sent to", prepareAttributedReceivers()),
                ("Date", NSAttributedString(string: requestDetails.date, attributes: defaultAttributes)),
                ("Amount", prepareAttributedAmount())]
    }
    
    private func prepareRequestSenderAttributedName() -> NSAttributedString {
        let currentTheme = ThemeProvider.currentTheme
        let attributedName = NSMutableAttributedString(string: requestDetails.sentFrom.name,
                                                       attributes: defaultAttributes)
        
        if requestDetails.isSentByMe {
            let attributedSuffix = NSAttributedString(string: " (You)", attributes: [.foregroundColor: currentTheme.colors.gradientLightGreen,
                                                                                    .font: currentTheme.fonts.rubikItalic(ofSize: 17)])
            
            attributedName.append(attributedSuffix)
        }
        
        return attributedName
    }
         
    private func prepareAttributedReceivers() -> NSAttributedString {
        let receivers = requestDetails.sentTo.map { $0.name }.joined(separator: ", ")
        
        return NSAttributedString(string: receivers, attributes: defaultAttributes)
    }
    
    private func prepareAttributedAmount() -> NSAttributedString {
        return NSAttributedString(string: "$\(requestDetails.amount)", attributes: defaultAttributes)
    }
}
