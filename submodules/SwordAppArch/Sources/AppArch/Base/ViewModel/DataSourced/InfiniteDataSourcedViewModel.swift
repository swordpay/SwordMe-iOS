//
//  InfiniteDataSourcedViewModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 06.07.22.
//

import Combine
import Foundation

public enum FetchingType {
    case `default`
    case refresh
    case infinity
}

public enum InfinityLoadingDirection {
    case top
    case bottom
}

public class InfiniteDataSourcedViewModel<Inputs, Section: Sectioning, Response: MetadataPresentable>: BaseViewModel<Inputs>, InfinityLoadingDataSourced {
    public typealias Section = Section
    
    public var dataSource: CurrentValueSubject<[Section], Never> = CurrentValueSubject([])
    public var addedRowsInfo: TableViewUpdatingDataModel = .init(status: .insert)
    public var deletedRowsInfo: TableViewUpdatingDataModel = .init(status: .deleted)
    public var hasRefreshableContent: Bool { return true }
    public var moreItemsLoadingPublisher: PassthroughSubject<Bool, Never> = PassthroughSubject()

    private var _isFetchingMoreItems: Bool = false
    
    public var direction: InfinityLoadingDirection {
        return .bottom
    }

    public var isFetchingMoreItems: Bool {
        return _isFetchingMoreItems
    }

    var existingDataSource: [Section] {
        return dataSource.value
    }
    
    var isMultiSectioned: Bool {
        return false
    }

    var limit: Int { return 10 }
    var page = 0

    private var hasMore = false

    func provideContentPublisher(fetchingType: FetchingType = .default) -> AnyPublisher<Response, Error> {
        fatalError("This method must be implemented in children")
    }
    private var isFetching = false
    
    public func prepareContent(fetchingType: FetchingType = .default) {
        guard !isFetching else { return }
        
        isFetching = true
        handleLoading(isLoading: true, fetchingType: fetchingType)
        provideContentPublisher(fetchingType: fetchingType)
            .sink { [ weak self ] completion in
                guard let self = self else { return }

                self.isFetching = false
                self.handleLoading(isLoading: false, fetchingType: fetchingType)
                self._isFetchingMoreItems = false
                switch completion {
                case .failure(let error):
                    self.error.send(error)
                    self.dataSource.send(self.existingDataSource)
                    print("Content fetching failed \(error)")
                case .finished:
                    print("Content fetching completed")
                }
            } receiveValue: { [ weak self ] response in
                self?.setupDataSource(with: response, fetchingType: fetchingType)
                if let metadata = response.metadata {
                    self?.updateMetadata(metadata)
                } else {
                    self?.hasMore = false
                }
            }
            .store(in: &cancellables)
    }

    private func setupDataSource(with response: Response, fetchingType: FetchingType) {
        guard !isMultiSectioned else {
            addedRowsInfo.cleanUp()

            if let dataSource = provideDataSourece(from: response, fetchingType: fetchingType) {
                self.dataSource.send(dataSource)
            }
            
            return
        }

        let isRefreshing = fetchingType == .refresh
        let newItems = cellModel(from: response)
        let newItemsCount = newItems.count
        var existingItems = isRefreshing ? [] : existingDataSource.first?.cellModels ?? []
        existingItems += newItems
        
        addedRowsInfo.cleanUp()

        if !dataSource.value.isEmpty && !isRefreshing {
            let rangeEnd = dataSource.value[0].cellModels.count + newItemsCount
            let indexPaths = (dataSource.value[0].cellModels.count..<rangeEnd).map { IndexPath(row: $0, section: 0) }
            addedRowsInfo.indexPaths = addedRowsInfo.indexPaths + indexPaths
        }
        
        guard !existingItems.isEmpty else {
            addedRowsInfo.cleanUp()

            dataSource.send([])

            return
        }

        let newSection = section(from: existingItems)
        
        dataSource.send([newSection])
    }

    public func cellModel(from response: Response) -> [Section.CellModel] {
        fatalError("This method must be implemented in children")
    }
    
    public func section(from cellModels: [Section.CellModel]) -> Section {
        fatalError("This method must be implemented in children")
    }
    
    func provideDataSourece(from response: Response, fetchingType: FetchingType) -> [Section]? {
        fatalError("This method must be implemented in children")
    }
    
    // MARK: - Loading
    
    func handleLoading(isLoading: Bool, fetchingType: FetchingType) {
        switch fetchingType {
        case .default:
            self.isLoading.send(isLoading)
        case .infinity:
            moreItemsLoadingPublisher.send(isLoading)
        case .refresh:
            return
        }
    }

    // MARK: - Refresh Handler

    public func refreshData() {
        page = 0
        prepareContent(fetchingType: .refresh)
    }
    
    // MARK: - Load More Logic
    
    private func updateMetadata(_ metadata: ResponseMetaData) {
        hasMore = metadata.hasNext
        page += 1
    }
    
    public func fetchMoreItems() {
        guard hasMore else { return }
        
        _isFetchingMoreItems = true
        prepareContent(fetchingType: .infinity)
    }
}
