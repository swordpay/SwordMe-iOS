//
//  ChannelParticipantsPickerCellModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 21.12.22.
//

import Combine
import Foundation
import Kingfisher
import TelegramCore

final class ChannelParticipantsPickerCellModel {
    private var cancellables: Set<AnyCancellable> = []

    var isForMultipleSelection: Bool
    var participent: ChannelsHeaderViewModel.Info
    
    var isSelected: CurrentValueSubject<Bool, Never>
    var areIconsRadioButtons: Bool
    
    init(isForMultipleSelection: Bool,
         participent: ChannelsHeaderViewModel.Info,
         isSelected: Bool,
         areIconsRadioButtons: Bool = false) {
        self.isForMultipleSelection = isForMultipleSelection
        self.participent = participent
        self.isSelected = CurrentValueSubject(isSelected)
        self.areIconsRadioButtons = areIconsRadioButtons
    }
}
