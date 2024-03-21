//
//  CryptoPickerViewController.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 09.03.23.
//

import UIKit

final class CryptoPickerViewController: GenericTableViewController<CryptoPickerViewModel, TitledTableHeaderAndFooterView, CryptoPickerItemCell, EmptyHeaderAndFooterView> {
    
    // MARK: - Properties
    
    override var shouldRespectSafeArea: Bool {
        return false
    }

    override var headerContainerViewInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 25, left: 20, bottom: -5, right: -20)
    }
    override var contentContainerViewInsets: UIEdgeInsets { return .zero }

    override func emptyStateViewProvider() -> UIView? {
        guard let emptyView = TextedEmptyStateView.loadFromNib() else { return nil }

        emptyView.setup(with: viewModel.emptyStateModel)

        return emptyView
    }

    // MARK: - Lifecycle Methods
    
    override func displayNodeDidLoad() {
        super.displayNodeDidLoad()
        
        setupHeaderView()
        viewModel.setupData()

        tableView.contentInset = .init(top: 0, left: 0, bottom: 25, right: 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.insertRemainingItemsIfNeeded()
    }

    // MARK: - Setup UI

    private func setupHeaderView() {
        guard let headerView = SearchBarHeaderView.loadFromNib(),
              let draggerView = DraggerView.loadFromNib() else { return }
        
        draggerView.setup(with: ())
        headerView.setup(with: viewModel.headerViewModel)
        headerView.setCornerRadius()

        let stackView = UIStackView(arrangedSubviews: [draggerView, headerView])
        stackView.axis = .vertical
        stackView.spacing = 10
        
        self.headerView = stackView
    }

    // MARK: - TableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedModel = viewModel.cellModel(for: indexPath) else { return }
        let cryptoInfo = selectedModel.cryptoMainInfo

        viewModel.selectedCrypto.send(cryptoInfo)
        
        self.dismiss(animated: true)
    }
}
