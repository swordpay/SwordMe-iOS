//
//  ChannelPaymentSectionHeaderViewModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 27.12.22.
//

import Combine
import Foundation

final class ChannelPaymentSectionHeaderViewModel: Emptiable {
    var isEmpty: Bool { return false }
    let isRequestingFromEveryone: CurrentValueSubject<Bool, Never> = CurrentValueSubject(true)
}
