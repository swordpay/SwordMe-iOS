//
//  SearchableGenericTableViewController.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 22.12.22.
//

import UIKit

class SearchableGenericTableViewController<ViewModel: SearchableDataSourced & InfinityLoadingDataSourced, HeaderView: SetupableView, CellView: SetupableTableViewCell, FooterView: SetupableView>: InfinityLoadingTableViewController<ViewModel, HeaderView, CellView, FooterView>, UISearchBarDelegate where ViewModel.Section.HeaderModel == HeaderView.SetupModel,
                                                                                  ViewModel.Section.CellModel == CellView.SetupModel,
                                                                                  ViewModel.Section.FooterModel == FooterView.SetupModel {
    lazy var searchBar: UISearchBar = {
        let bar = UISearchBar()

        bar.delegate = self
        bar.smartQuotesType = .no
        bar.placeholder = Constants.Localization.Common.search
        bar.translatesAutoresizingMaskIntoConstraints = false

        return bar
    }()

    // MARK: - Binding

    override func bindViewModel() {
        super.bindViewModel()

        bindToIsSearchable()
    }

    private func bindToIsSearchable() {
        viewModel.isSearchable
            .removeDuplicates()
            .subscribe(on: RunLoop.main)
            .sink { [ weak self ] isSearchable in
                self?.updateHeaderView(isSearchable: isSearchable)
            }
            .store(in: &cancellables)
    }

    // MARK: - Setup UI

    private func updateHeaderView(isSearchable: Bool) {
        headerView = isSearchable ? searchBar : nil
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchTerm.send(searchText)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        viewModel.searchTerm.send(searchBar.text ?? "")
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        viewModel.handleSearchCancel()
    }
}
