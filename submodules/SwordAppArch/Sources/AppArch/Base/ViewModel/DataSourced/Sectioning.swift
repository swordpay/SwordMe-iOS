//
//  Sectioning.swift
//  sword-ios
//
//  Created by Scylla IOS on 27.05.22.
//

import Foundation

public protocol Sectioning {
    associatedtype HeaderModel: Emptiable
    associatedtype CellModel
    associatedtype FooterModel: Emptiable

    var headerModel: HeaderModel { get }
    var cellModels: [CellModel] { get }
    var footerModel: FooterModel { get }
}
