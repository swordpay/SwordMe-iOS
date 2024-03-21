//
//  DataSoursed.swift
//  sword-ios
//
//  Created by Scylla IOS on 27.05.22.
//

import UIKit
import Combine

public protocol InfinityLoadingDataSourced: DataSourced {
    var direction: InfinityLoadingDirection { get }
    var isFetchingMoreItems: Bool { get }
    var moreItemsLoadingPublisher: PassthroughSubject<Bool, Never> { get }

    func fetchMoreItems()
}

extension InfinityLoadingDataSourced {
    var isFetchingMoreItems: Bool { return false }

    func fetchMoreItems() {}
}

public protocol DataSourced: ViewModeling {
    associatedtype Section: Sectioning
    
    var dataSource: CurrentValueSubject<[Section], Never> { get set }
    var addedRowsInfo: TableViewUpdatingDataModel { get set }
    var deletedRowsInfo: TableViewUpdatingDataModel { get set }
    var hasRefreshableContent: Bool { get }

    func refreshData()
}

// MARK: - Default Implementation

extension DataSourced {
    public var hasRefreshableContent: Bool { return false }

    public func refreshData() {}
}

// MARK: - Helper Methods

extension DataSourced {
    func lastItemIndexPath(sections: [Section]? = nil) -> IndexPath? {
        let unwrapedSections = sections ?? dataSource.value

        guard let lastSection = unwrapedSections.last,
              !lastSection.cellModels.isEmpty else { return nil }

        let section = unwrapedSections.count - 1
        let row = lastSection.cellModels.count - 1

        return IndexPath(row: row, section: section)
    }

    func cellModel(for indexPath: IndexPath) -> Section.CellModel? {
        return dataSource.value[safe: indexPath.section]?.cellModels[safe: indexPath.row]
    }
    
    func headerModel(for section: Int) -> Section.HeaderModel? {
        return dataSource.value[safe: section]?.headerModel
    }

    func footerModel(for section: Int) -> Section.FooterModel? {
        return dataSource.value[safe: section]?.footerModel
    }
}

public struct TableViewUpdatingDataModel {
    var sections: [Int] = []
    var indexPaths: [IndexPath] = []
    var status: Status
    
    var hasUpdatableData: Bool {
        return !sections.isEmpty || !indexPaths.isEmpty
    }

    init(status: Status) {
        self.status = status
    }

    public enum Status {
        case insert
        case deleted
    }
    
    mutating func cleanUp() {
        sections = []
        indexPaths = []
    }
}
