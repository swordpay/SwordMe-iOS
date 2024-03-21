//
//  TitledReusableViewModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 21.12.22.
//

import Combine
import Foundation

public class TitledReusableViewModel: Emptiable {
    public var isEmpty: Bool { return title.value.isEmpty }
    var title: CurrentValueSubject<String, Never>

    init(title: String) {
        self.title = CurrentValueSubject(title)
    }
}
