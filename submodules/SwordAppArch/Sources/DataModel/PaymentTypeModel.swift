//
//  PaymentTypeModel.swift
//  SwordAppArch
//
//  Created by Tigran Simonyan on 16.11.23.
//

import UIKit
import Combine

struct PaymentTypeModel {
    let title: String
    let description: String
    let backgroundColor: UIColor
    let iconName: String
    var isActionButtonEnabled: CurrentValueSubject<Bool, Never>
    let isSelected: CurrentValueSubject<Bool, Never>
}

struct FiatPaymentMethodType: Codable {
    let id: String
    let createdAt: String
    let updatedAt: String
    let paymentType: String
}
