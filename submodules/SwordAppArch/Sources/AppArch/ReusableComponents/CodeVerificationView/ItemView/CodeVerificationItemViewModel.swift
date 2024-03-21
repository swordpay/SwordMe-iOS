//
//  CodeVerificationItemViewModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 07.05.23.
//

import Combine
import Foundation
 
final class CodeVerificationItemViewModel {
    var currentText: String?
    let textToUpdatePublisher: PassthroughSubject<String?, Never> = PassthroughSubject()
    
    init(currentText: String? = nil) {
        self.currentText = currentText
    }
    
}
