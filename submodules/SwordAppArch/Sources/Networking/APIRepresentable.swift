//
//  APIRepresentable.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 12.04.22.
//

import Foundation

public protocol APIRepresentable {
    var path: String { get }
    var fileName: String { get }
}

