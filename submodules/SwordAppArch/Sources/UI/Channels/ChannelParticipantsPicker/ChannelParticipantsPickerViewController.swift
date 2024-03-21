//
//  ChannelParticipantsPickerViewController.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 21.12.22.
//

import UIKit

final class ChannelParticipantsPickerViewController: GenericTableViewController<ChannelParticipantsPickerViewModel, TitledTableHeaderAndFooterView, ChannelParticipantsPickerCell, EmptyHeaderAndFooterView> {
    // MARK: - Properties
    
    override var shouldRespectSafeArea: Bool { return false }
    override var headerContainerViewInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
    }

    override var contentContainerViewInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    override func emptyStateViewProvider() -> UIView? {
        guard let emptyView = TextedEmptyStateView.loadFromNib() else { return nil }

        emptyView.setup(with: viewModel.emptyStateModel)

        return emptyView
    }

    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.interactivePopGestureRecognizer?.delegate = self

        setupHeaderView()
    }

    // MARK: - Setup UI
    
    private func setupHeaderView() {
        guard let headerView = ChannelParticipantsPickerHeaderView.loadFromNib(),
              let draggerView = DraggerView.loadFromNib() else { return }
        
        draggerView.setup(with: ())
        headerView.setup(with: viewModel.headerSetupModel)
        
        let stackView = UIStackView(arrangedSubviews: [draggerView, headerView])
        stackView.axis = .vertical
        stackView.spacing = 5
        
        self.headerView = stackView
    }
    
    // MARK: - Bninding
    
    override func bindViewModel() {
        super.bindViewModel()
        
        bindToDoneButton()
        bindToOpenPaymentScreenPublisher()
    }

    private func bindToDoneButton() {
        viewModel.headerSetupModel.doneButtonTouchHandler
            .sink { [ weak self ] in
                self?.viewModel.additionalPeersPublisher.send(self?.viewModel.selectedParticipants.value ?? [])
                self?.navigator.goTo(BackDestination.dismiss(animated: true, completion: nil))
            }
            .store(in: &cancellables)
    }

    private func bindToOpenPaymentScreenPublisher() {
        viewModel.openPaymentScreenPublisher
            .sink { [ weak self ] stateInfo in
                self?.goToChannelPaymentScreen(stateInfo: stateInfo)
            }
            .store(in: &cancellables)
    }

    // MARK: - Navigation
    
    private func goToChannelPaymentScreen(stateInfo: PayOrRequestStateInfoModel) {
        guard let rootViewController = navigationController?.viewControllers.first as? Navigatable else { return }

        let destination = ChannelsDestination.channelPayment(stateInfo: stateInfo)

        navigator.goTo(BackDestination.pop(animated: true))        
        rootViewController.navigator.goTo(destination)
    }
    
    // MARK: - TableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.handleSelectedItem(at: indexPath)
    }
}

extension ChannelParticipantsPickerViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
