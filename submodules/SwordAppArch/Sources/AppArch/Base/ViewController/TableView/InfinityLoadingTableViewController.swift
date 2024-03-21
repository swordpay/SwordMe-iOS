//
//  InfinityLoadingTableViewController.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 11.07.22.
//

import UIKit
import Display

public class InfinityLoadingTableViewController<ViewModel: InfinityLoadingDataSourced,
                                         HeaderView: SetupableView,
                                         Cell: SetupableTableViewCell,
                                         FooterView: SetupableView>: GenericTableViewController<ViewModel, HeaderView, Cell, FooterView> where HeaderView.SetupModel == ViewModel.Section.HeaderModel, Cell.SetupModel == ViewModel.Section.CellModel, FooterView.SetupModel == ViewModel.Section.FooterModel {
    
    private var infinityLoadingView: FooterLoadingView?
    
    // MARK: - Init
    
    public override init(viewModel: ViewModel? = nil) {
        super.init(viewModel: viewModel)
    }

    public override init(viewModel: ViewModel? = nil, navigationBarPresentationData: NavigationBarPresentationData?) {
        super.init(viewModel: viewModel, navigationBarPresentationData: navigationBarPresentationData)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupInfinityLoadingView()
    }
    
    // MARK: Setup UI
    
    private func setupInfinityLoadingView() {
        guard let loadingView = FooterLoadingView.loadFromNib() else { return }
        
        loadingView.setup(with: .init())
        
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.alpha = 0
        
        view.addSubview(loadingView)
        loadingView.addBorderConstraints(constraintSides: .horizontal)

        let laodingViewVerticalAnchor = viewModel.direction == .top ? loadingView.topAnchor : loadingView.bottomAnchor
        let parentViewVerticalAnchor = viewModel.direction == .top ? contentContainerView.topAnchor : contentContainerView.bottomAnchor
        NSLayoutConstraint.activate([
            laodingViewVerticalAnchor.constraint(equalTo: parentViewVerticalAnchor)
        ])
        
        infinityLoadingView = loadingView
    }

    override func handleItemsInsertion(data: TableViewUpdatingDataModel) {
        tableView.performBatchUpdates { [ weak self ] in
            self?.tableView.insertRows(at: data.indexPaths, with: .none)
            self?.tableView.insertSections(IndexSet(data.sections), with: .none)
        } completion: {[ weak self ] _ in
            guard let self else { return }
            
            self.viewModel.addedRowsInfo.cleanUp()
            
            guard self.tableView.contentOffset.y != 0 else { return }

            UIView.animate(withDuration: 0.25) {
                self.tableView.contentOffset.y += 40
            }
        }
    }

    override func handleItemsDeletion(data: TableViewUpdatingDataModel) {
        super.handleItemsDeletion(data: data)
    }

    // MARK: - Binding
    
    open override func bindViewModel() {
        super.bindViewModel()
        
        
        bindToInfinityLoadingPublisher()
    }
    
    private func bindToInfinityLoadingPublisher() {
        viewModel.moreItemsLoadingPublisher
            .receive(on: RunLoop.main)
            .sink { [ weak self ] isLoading in
                self?.setupTableViewLoadingView(isLoading: isLoading)
            }
            .store(in: &cancellables)
    }
    
    private func setupTableViewLoadingView(isLoading: Bool) {
        let alpha: CGFloat = isLoading ? 1 : 0
        
        UIView.animate(withDuration: 0.05) {
            self.infinityLoadingView?.alpha = alpha
        }
    }
    
    // MARK: - UITableView Delegate
    
    private var isFetched = false
    
    public override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard !isFetched else { return }
        
        guard let lastIndexPath = viewModel.lastItemIndexPath(),
              lastIndexPath.row == indexPath.row, lastIndexPath.section == indexPath.section else { return }

        isFetched = true
        if !viewModel.isFetchingMoreItems {
            viewModel.fetchMoreItems()
        }
    }
    
    public override func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
    }

    public override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.contentOffset.y > 0,
              scrollView.contentSize.height > 0,
              scrollView.contentSize.height - scrollView.contentOffset.y - scrollView.frame.height <= scrollView.frame.height / 2 else { return }
        
        
        if !viewModel.isFetchingMoreItems {
            viewModel.fetchMoreItems()
        }
    }
}
