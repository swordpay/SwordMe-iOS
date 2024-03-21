//
//  CryptoAccountModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 09.03.23.
//

import Combine
import Foundation

public final class CryptoAccountModel {
    var balance: CurrentValueSubject<Double, Never>
    let balanceInEuro: CurrentValueSubject<Double, Never>
    let totalReturn: Double
    let totalReturnByPercent: Double
    
    init(balance: Double, balanceInEuro: Double, totalReturn: Double, totalReturnByPercent: Double) {
        self.balance = CurrentValueSubject(balance)
        self.balanceInEuro = CurrentValueSubject(balanceInEuro)
        self.totalReturn = totalReturn
        self.totalReturnByPercent = totalReturnByPercent
    }
}
