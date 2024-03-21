//
//  TextPlaceholderedImageViewModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 26.12.22.
//

import Combine
import Foundation

final class TextPlaceholderedImageViewModel {
    let imageData: CurrentValueSubject<Data?, Never>
    var title: CurrentValueSubject<String, Never>
    let fontSize: CGFloat
    let cornerRadius: CGFloat
    
    init(imageData: Data?, title: String, fontSize: CGFloat, cornerRadius: CGFloat) {
        self.imageData = CurrentValueSubject(imageData)
        self.title = CurrentValueSubject(title)
        self.fontSize = fontSize
        self.cornerRadius = cornerRadius
    }
}
