//
//  ChannelsViewController.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 20.12.22.
//

import UIKit
import Combine

final class ChannelsViewController: InfinityLoadingTableViewController<ChannelsViewModel, EmptyHeaderAndFooterView, ChannelItemCell, EmptyHeaderAndFooterView> {
    // MARK: - Properties
    
    private var deepLinkHandlerCancellable: AnyCancellable?

    override var headerContainerViewInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: -15, right: 0)
    }

    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.getUserInfo()
    }
    
    override func emptyStateViewProvider() -> UIView? {
        guard let emptyView = ChannelsEmptyStateView.loadFromNib() else { return nil }

        emptyView.setup(with: viewModel.emptyStateViewModel)

        return emptyView
    }
    
    private func setupHeaderView(with model: ChannelsHeaderViewModel) {
        guard let headerView = ChannelsHeaderView.loadFromNib() else { return }
        
        headerView.setup(with: model)
        
        self.headerView = headerView
    }

    // MARK: - Data Source Update handling
    
    override func handleDataSource(_ dataSource: [ChannelsSection]) {
        if dataSource.isEmpty {
            self.viewModel.isEmptyState.send(true)
            self.tableView.reloadData()
            self.viewModel.deletedRowsInfo.cleanUp()
            self.viewModel.addedRowsInfo.cleanUp()
            viewModel.addPendingChannels()
        } else {
            self.viewModel.isEmptyState.send(false)

            if self.contentView != self.tableView {
                self.contentView = self.tableView
            }

            if self.viewModel.addedRowsInfo.hasUpdatableData {
                self.handleItemsInsertion(data: self.viewModel.addedRowsInfo)
            } else if self.viewModel.deletedRowsInfo.hasUpdatableData {
                self.handleItemsDeletion(data: self.viewModel.deletedRowsInfo)
            } else {
                self.tableView.reloadData()
                self.viewModel.isBatchUpdating = false
            }
        }

        self.refreshControl.endRefreshing()
    }

    override func handleItemsInsertion(data: TableViewUpdatingDataModel) {
        viewModel.isBatchUpdating = true
        tableView.performBatchUpdates { [ weak self ] in
            self?.tableView.insertRows(at: data.indexPaths, with: .none)
            self?.tableView.insertSections(IndexSet(data.sections), with: .none)
        } completion: {[ weak self ] completed in
            guard let self else { return }
            
            print("Insertedd")
            self.viewModel.isBatchUpdating = false
            self.viewModel.addedRowsInfo.cleanUp()
            self.viewModel.addPendingChannels()

            guard self.tableView.contentOffset.y != 0 else { return }

            UIView.animate(withDuration: 0.25) {
                self.tableView.contentOffset.y += 40
            }
        }
    }

    override func handleItemsDeletion(data: TableViewUpdatingDataModel) {
        viewModel.isBatchUpdating = true

        tableView.performBatchUpdates { [ weak self ] in
            self?.tableView.deleteRows(at: data.indexPaths, with: .none)
            self?.tableView.deleteSections(IndexSet(data.sections), with: .none)
        } completion: {[ weak self ] completed in
            self?.viewModel.isBatchUpdating = false
            self?.viewModel.deletedRowsInfo.cleanUp()
            self?.viewModel.addPendingChannels()
        }
    }

    // MARK: - Binding
    
    override func bindViewModel() {
        super.bindViewModel()
        
        bindToHeaderModel()
        bindToCellToMoveToTopIndexPath()
    }
        
    private func bindToCellToMoveToTopIndexPath() {
        viewModel.cellToMoveToTopIndexPath
            .sink { [ weak self ] indexPath in
                self?.moveToTopCell(at: indexPath)
            }
            .store(in: &cancellables)
    }
    
    private func bindToHeaderModel() {
        viewModel.headerModel
            .sink { [ weak self ] model in
                guard let self, let model else { return }
                
                self.setupHeaderView(with: model)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - TableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let channelItem = viewModel.cellModel(for: indexPath)?.channel.value else { return }

        viewModel.selectedChannel.send(channelItem)
    }
    
    // MARK: - Table View Delegate
    
    #if PROD
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [ weak self] (_, _, completionHandler) in
            self?.viewModel.removeChannel(at: indexPath) { isDeleted in
                completionHandler(isDeleted)
            }
        }
        
        deleteAction.image = UIImage(imageName: Constants.AssetName.Common.backgroundedTrash)
        deleteAction.backgroundColor = theme.colors.mainWhite
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        
        return configuration
    }
    
    #endif
        
    // MARK: - Helpers
    
    private func moveToTopCell(at indexPath: IndexPath) {
        guard !viewModel.dataSource.value.isEmpty else { return }

        tableView.moveRow(at: indexPath, to: IndexPath(row: 0, section: 0))
    }
}

extension ChannelsViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        if viewModel.channelsInfoDidChange {
            viewModel.prepareContent(fetchingType: .refresh)
            viewModel.channelsInfoDidChange = false
        }
    }
}
