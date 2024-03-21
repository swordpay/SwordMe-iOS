//
//  SearchBarHeaderView.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 21.12.22.
//

import UIKit
import Combine

private let searchIcon = UIImage(systemName: "magnifyingglass")

final class SearchBarHeaderView: SetupableView {
    // MARK: - IBOutlets
    @IBOutlet private weak var searchBar: UISearchBar!
    
    // MARK: - Properties
    
    private var model: SearchBarHeaderViewModel!
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Setup UI
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        searchBar.setPlaceHolder(text: model.placeholder)
    }

    func setup(with model: SearchBarHeaderViewModel) {
        self.model = model
        
        searchBar.delegate = self
        searchBar.tintColor = theme.colors.textColor.withAlphaComponent(0.8)
        searchBar.setCornerRadius(18)
        searchBar.setImage(searchIcon, for: .search, state: .normal)
        searchBar.searchTextField.layoutMargins = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        searchBar.searchTextField.font = theme.fonts.regular(ofSize: 16, family: .poppins)
        searchBar.searchTextField.setupKeyboardToolbar()
        searchBar.searchTextField.borderStyle = .none
        
        searchBar.searchTextField.textColor = UIColor(rgb: 0x000000)
        searchBar.backgroundColor = theme.colors.lightBlue2

        bindToLoading()
    }
    
    private func cleanChildrenBackgroundCclor(of view: UIView) {
        view.backgroundColor = .clear
        
        view.subviews.forEach {
            cleanChildrenBackgroundCclor(of: $0)
        }
    }

    // MARK: - Binding
    
    private func bindToLoading() {
        model.isLoading
            .receive(on: RunLoop.main)
            .sink { [ weak self ] isLoading in
                self?.configureTextFieldLeftView(isLoading: isLoading)
            }
            .store(in: &cancellables)
    }

    func configureTextFieldLeftView(isLoading: Bool) {
        let viewFrame = CGRect(x: 0, y: 0, width: 25, height: 25)
        let view: UIView
        
        if isLoading {
            let activityIndicator = UIActivityIndicatorView(frame: viewFrame)
            activityIndicator.startAnimating()
            
            view = activityIndicator
        } else {
            let imageView = UIImageView(frame: viewFrame)
            imageView.image = searchIcon
            imageView.tintColor = UIColor(rgb: 0x8e8e93)
            view = imageView
        }
        
        searchBar.searchTextField.leftView = view
        searchBar.searchTextField.leftViewMode = .always
    }
}

extension SearchBarHeaderView: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        model.searchTerm.send(searchText)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        model.searchTerm.send(searchBar.text ?? "")
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        UIView.animate(withDuration: 0.2) {
            searchBar.setPositionAdjustment(.zero, for: .search)
            self.searchBar.layoutIfNeeded()
        }
        model.isSearchActive.send(true)
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        model.isSearchActive.send(false)
        if (searchBar.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            searchBar.setPlaceHolder(text: model.placeholder, animated: true)
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        model.searchCancelPublisher.send(())
    }
}
