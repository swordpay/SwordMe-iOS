//
//  GenericViewController.swift
//  sword-ios
//
//  Created by Scylla IOS on 27.05.22.
//

import UIKit
import Combine
import Display

public typealias SetupableTableViewCell = UITableViewCell & Setupable

public class GenericTableViewController<ViewModel: DataSourced, HeaderView: SetupableView, Cell: SetupableTableViewCell, FooterView: SetupableView>: HeaderFooterViewController<ViewModel>, UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching where HeaderView.SetupModel == ViewModel.Section.HeaderModel, Cell.SetupModel == ViewModel.Section.CellModel, FooterView.SetupModel == ViewModel.Section.FooterModel {
    
    var isUpdatingData: Bool = false
    public var refreshControl = UIRefreshControl()
    public var tableView: UITableView = UITableView(frame: .zero, style: .grouped)

    var needToOverrideKeyboardChangesHandler: Bool { return true }
    var cellIdentifier: String { return String(describing: Cell.self) }
    var headerIdentifier: String { return String(describing: HeaderView.self) }
    var footerIdentifier: String { return String(describing: FooterView.self) }
    
    override var contentContainerViewInsets: UIEdgeInsets { return UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0) }
    
    public override init(viewModel: ViewModel? = nil) {
        super.init(viewModel: viewModel)
    }

    public override init(viewModel: ViewModel? = nil, navigationBarPresentationData: NavigationBarPresentationData?) {
        super.init(viewModel: viewModel, navigationBarPresentationData: navigationBarPresentationData)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle Methods

    public override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    public override func displayNodeDidLoad() {
        super.displayNodeDidLoad()
        
        setupTableView()
        setupRefreshControl()
    }

    // MARK: - Binding

    open override func bindViewModel() {
        super.bindViewModel()

        bindDataSource()
    }
    
    func registerReusableComponents() {
        tableView.register(UINib(nibName: "\(HeaderView.self)", bundle: Constants.mainBundle), forHeaderFooterViewReuseIdentifier: headerIdentifier)
        tableView.register(UINib(nibName: "\(Cell.self)", bundle: Constants.mainBundle), forCellReuseIdentifier: cellIdentifier)
        tableView.register(UINib(nibName: "\(FooterView.self)", bundle: Constants.mainBundle), forHeaderFooterViewReuseIdentifier: footerIdentifier)
    }

    func removeTableViewTopPadding() {
        if #available(iOS 15.0, *) {
            self.tableView.sectionHeaderTopPadding = 0
        }
    }

    public func setupTableView() {
        registerReusableComponents()
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
        removeTableViewTopPadding()
        
        contentView = tableView
    }
    
    public func setupRefreshControl() {
        guard viewModel.hasRefreshableContent else { return }

        refreshControl.tintColor = theme.colors.textColor
        refreshControl.attributedTitle = NSAttributedString(string: "\(Constants.Localization.Common.loading)...",
                                                            attributes: [.font: theme.fonts.regular(ofSize: 12, family: .poppins),
                                                                         .foregroundColor: theme.colors.textColor])
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }

    func bindDataSource() {
        viewModel.dataSource
            .receive(on: RunLoop.main)
            .dropFirst()
            .sink { [ weak self ] dataSource in
                guard let self = self else { return }

                self.handleDataSource(dataSource)
            }
            .store(in: &cancellables)
    }

    func handleDataSource(_ dataSource: [ViewModel.Section]) {
        if dataSource.isEmpty {
            self.viewModel.isEmptyState.send(true)
            self.tableView.reloadData()
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
            }
        }

        self.refreshControl.endRefreshing()
    }

    // MARK: - Table View Items Insertion

    func handleItemsInsertion(data: TableViewUpdatingDataModel) {
        tableView.performBatchUpdates { [ weak self ] in
            self?.tableView.insertRows(at: data.indexPaths, with: .none)
            self?.tableView.insertSections(IndexSet(data.sections), with: .none)
        } completion: {[ weak self ] _ in
            self?.viewModel.addedRowsInfo.cleanUp()
        }
    }

    func handleItemsDeletion(data: TableViewUpdatingDataModel) {
        tableView.performBatchUpdates { [ weak self ] in
            self?.tableView.deleteRows(at: data.indexPaths, with: .none)
            self?.tableView.deleteSections(IndexSet(data.sections), with: .none)
        } completion: {[ weak self ] _ in
            self?.viewModel.deletedRowsInfo.cleanUp()
        }
    }
    
    // MARK: - Refresh Handler

    @objc
    public func refreshData() {
        viewModel.refreshData()
    }

    // MARK: - TableView Delegate & DataSource
    public func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.dataSource.value.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSource.value[section].cellModels.count

    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellModel = viewModel.cellModel(for: indexPath),
              let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? Cell else {
            return UITableViewCell()
        }
        
        cell.setup(with: cellModel)
        cell.selectionStyle = .none
        cell.separatorInset = .zero
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerModel = viewModel.headerModel(for: section),
              !headerModel.isEmpty,
              let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerIdentifier) as? HeaderView else { return nil }

        view.setup(with: headerModel)

        return view
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footerModel = viewModel.footerModel(for: section),
              !footerModel.isEmpty,
            let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: footerIdentifier) as? FooterView else { return nil }

            view.setup(with: footerModel)

        return view
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let model = viewModel.headerModel(for: section) else { return 0 }
        
        return model.isEmpty ? 0 : UITableView.automaticDimension
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard let model = viewModel.footerModel(for: section) else { return 0 }

        return model.isEmpty ? 0 : UITableView.automaticDimension
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

    public func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return nil
    }
    
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {

    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
    }
    
    // MARK: - Keyboard Frame Change Handling

    override func handleKeyboardFrameChange(isHidden: Bool, frame: CGRect, duration: Double, curve: UIView.AnimationCurve) {
        guard needToOverrideKeyboardChangesHandler else {
            super.handleKeyboardFrameChange(isHidden: isHidden, frame: frame, duration: duration, curve: curve)

            return
        }

        let tableViewBottomInset = isHidden ? 0 : frame.size.height
        let animator = UIViewPropertyAnimator(duration: duration,
                                              curve: curve) { [ weak self ] in
            self?.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: tableViewBottomInset, right: 0)
        }

        animator.startAnimation()
    }
}
