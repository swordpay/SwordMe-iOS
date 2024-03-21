//
//  Array+Addition.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 21.06.22.
//

import Foundation

extension Array {
    subscript(safe index: Int) -> Element? {
        guard (0..<count).contains(index) else { return nil }
        return self[index]
    }
}
