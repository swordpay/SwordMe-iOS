//
//  SearchableDataSourced.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 22.12.22.
//

import Combine
import Foundation

protocol SearchableDataSourced: DataSourced {
    var isSearchable: CurrentValueSubject<Bool, Never> { get }
    var searchTerm: PassthroughSubject<String, Never> { get }

    func handleSearchTerm(_ term: String)
    func handleSearchCancel()
}

class SearchableDataSource<Inputs, Section: Sectioning, Response: MetadataPresentable>: InfiniteDataSourcedViewModel<Inputs, Section, Response>, SearchableDataSourced {
    typealias Section = Section

    var isSearchable: CurrentValueSubject<Bool, Never>
    var searchTerm: PassthroughSubject<String, Never> = PassthroughSubject()

    init(inputs: Inputs, isSearchable: Bool = true) {
        self.isSearchable = CurrentValueSubject(isSearchable)

        super.init(inputs: inputs)

        bindToSearchTerm()
    }

    func handleSearchTerm(_ term: String) {

    }

    func handleSearchCancel() {

    }

    // MARK: - Binding

    private func bindToSearchTerm() {
        searchTerm
            .debounce(for: .seconds(0.25), scheduler: DispatchQueue.global())
            .share()
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [ weak self ] term in
                self?.handleSearchTerm(term)
            })
            .store(in: &cancellables)
    }
}
