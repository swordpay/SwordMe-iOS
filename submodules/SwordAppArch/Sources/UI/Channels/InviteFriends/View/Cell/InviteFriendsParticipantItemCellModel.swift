//
//  InviteFriendsParticipantItemCellModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 05.04.23.
//

import Combine
import Foundation

final class InviteFriendsParticipantItemCellModel {
    var isForMultipleSelection: Bool
    var participent: MessageParticipant
    
    var isSelected: CurrentValueSubject<Bool, Never>
    var areIconsRadioButtons: Bool
    
    var selectedImageName: String {
        return areIconsRadioButtons ? Constants.AssetName.Common.radioSelected : Constants.AssetName.Common.termsSelectedCheckmark
    }
    
    var unselectedImageName: String {
        return areIconsRadioButtons ? Constants.AssetName.Common.radioUnselected : Constants.AssetName.Common.termsUnselectedCheckmark
    }
    
    init(isForMultipleSelection: Bool,
         participent: MessageParticipant,
         isSelected: Bool,
         areIconsRadioButtons: Bool = false) {
        self.isForMultipleSelection = isForMultipleSelection
        self.participent = participent
        self.isSelected = CurrentValueSubject(isSelected)
        self.areIconsRadioButtons = areIconsRadioButtons
    }
}
