//
//  BottomSheetPresentable.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 12.09.22.
//

import UIKit

protocol BottomSheetPresentable {
    var bottomSheetPresentor: BottomSheetPresentor? { get set }
    
    func presentAsBottomSheet(_ view: UIView, on parentView: UIView?, height: CGFloat, onDismiss: Constants.Typealias.VoidHandler?)
    func dismissBottomSheet(completion: Constants.Typealias.VoidHandler?)
}
