//
//  ResponseMetaData.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 21.06.22.
//

import Foundation

public protocol MetadataPresentable {
    var metadata: ResponseMetaData? { get }
}

public struct ResponseMetaData: Codable {
//    var total: Int = 0
    var hasNext: Bool
//    let currentPage: Int
//    let pageCount: Int
}
