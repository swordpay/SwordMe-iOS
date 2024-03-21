//
//  BottomSheetViewModel.swift
//  SwordAppArch
//
//  Created by Tigran Simonyan on 27.06.23.
//

import Combine
import Foundation

final class BottomSheetViewModel: BaseViewModel<Void>, StackViewModeling {
    
    var setupModel: CurrentValueSubject<BottomSheetStackViewModel?, Never> = .init(.init())
}
