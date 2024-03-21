//
//  ChannelRequestDetailsViewController.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 28.12.22.
//

import UIKit

final class ChannelRequestDetailsViewController: GenericTableViewController<ChannelRequestDetailsViewModel, ChannelRequestDetailsSectionHeaderView, ChannelRequestDetailsItemCell, EmptyHeaderAndFooterView> {
    // MARK: - Properties
    override var footerContainerViewInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: -10, right: -20)
    }

    override var headerContainerViewInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: -30, right: 0)
    }

    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = viewModel.isForRequestDetails ? Constants.Localization.Channels.requestDetails
                                              : Constants.Localization.Channels.paymentDetails
        
        setupHeaderView()
        setupFooterView()
        
        viewModel.provideDataSource()
    }
    
    // MARK: - Setup UI
    
    private func setupHeaderView() {
        guard let headerView = ChannelRequestDetailsHeaderView.loadFromNib() else { return }
        
        headerView.setup(with: ChannelRequestDetailsHeaderViewModel(requestDetails: viewModel.requestDetails))
        
        self.headerView = headerView
    }
    
    private func setupFooterView() {
        let button = UIButton()
        let buttonHeight: CGFloat = 54

        button.setTitle(Constants.Localization.Channels.closeRequest, for: .normal)
        button.setTitleColor(theme.colors.mainRed, for: .normal)
        button.layer.borderColor = theme.colors.mainRed.cgColor
        button.layer.borderWidth = 2
        button.titleLabel?.font = theme.fonts.bold(ofSize: 21, family: .rubik)
        button.addTarget(self, action: #selector(closeRequestButtonHandler), for: .touchUpInside)

        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: buttonHeight)
        ])
        
        button.layer.cornerRadius = buttonHeight / 2

        footerView = button
    }
    
    // MARK: - Binding
    
    override func bindViewModel() {
        super.bindViewModel()
        
        bindToCommentViewCancelAction()
        bindToCommentViewConfirmAction()
    }
    
    private func bindToCommentViewCancelAction() {
        viewModel.commentViewModel.cancelButtonPublisher
            .sink { [ weak self ] in
                self?.dismissBottomSheet()
            }
            .store(in: &cancellables)
    }

    private func bindToCommentViewConfirmAction() {
        viewModel.commentViewModel.rightSideButtonPublisher
            .sink { [ weak self ] in
                guard let self else { return }

                self.dismissBottomSheet {
                    self.viewModel.closeRequestCompletion.send((self.viewModel.requestDetails.messageId,
                                                                self.viewModel.commentViewModel.comment.value))
                    self.navigator.goTo(BackDestination.pop(animated: true))
                }
            }
            .store(in: &cancellables)
    }

    // MARK: - Actions
    
    @objc
    private func closeRequestButtonHandler() {
        guard let commentView = CommentBottomSheetView.loadFromNib() else { return }

        commentView.setup(with: viewModel.commentViewModel)

        presentAsBottomSheet(commentView, height: 320)
    }
}
