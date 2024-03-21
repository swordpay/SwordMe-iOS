//
//  HorizontalCollectionDataSourced.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 10.01.23.
//

import Combine
import Foundation

protocol HorizontalCollectionDataSourced {
    associatedtype CellModel
    
    var dataSource: CurrentValueSubject<[CellModel], Never> { get set }
    var currentItemIndexPath: CurrentValueSubject<IndexPath?, Never> { get }
    var initialSelectedIndex: Int? { get }
}
