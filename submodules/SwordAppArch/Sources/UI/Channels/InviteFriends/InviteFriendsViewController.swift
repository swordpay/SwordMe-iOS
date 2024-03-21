//
//  InviteFriendsViewController.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 08.02.23.
//

import UIKit
import Contacts
import MessageUI

final class InviteFriendsViewController: GenericTableViewController<InviteFriendsViewModel, TitledTableHeaderAndFooterView, InviteFriendsParticipantItemCell, EmptyHeaderAndFooterView> , MFMessageComposeViewControllerDelegate {
    
    // MARK: - Properties
    override var headerContainerViewInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 25, left: 10, bottom: -10, right: -10)
    }
    
    override var footerContainerViewInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: -10, right: -20)
    }

    override func emptyStateViewProvider() -> UIView? {
        if self.viewModel.contactsAuthorizationAccessStatus == .authorized {
            guard let emptyView = TextedEmptyStateView.loadFromNib() else { return nil }

            emptyView.setup(with: viewModel.textedEmptyStateViewModel)

            return emptyView
        } else {
            guard let emptyView = SystemServicePermissionAccessView.loadFromNib() else { return nil }

            emptyView.setup(with: viewModel.emptyStateViewModel)

            return emptyView
        }
    }

    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = Constants.Localization.Channels.friends

        checkContactsPermission()
        setupHeaderAndFooterViewsIfNeeded()
    }

    // MARK: - Setup UI
    
    private func setupHeaderView() {
        guard let searchView = SearchBarHeaderView.loadFromNib() else { return }
        
        searchView.setup(with: viewModel.headerViewModel)
        
//        let titleLabel = UILabel()
//
//        titleLabel.text = Constants.Localization.Channels.friends
//        titleLabel.font = theme.fonts.bold(ofSize: 22, family: .rubik)
//        titleLabel.textColor = theme.colors.textColor
//        titleLabel.textAlignment = .center
//
//        let stackView = UIStackView(arrangedSubviews: [titleLabel, searchView])
//        stackView.axis = .vertical
//        stackView.spacing = 10
        
        self.headerView = searchView
    }
    
    private func setupFooterView() {
        let inviteFriendsButton = GradientedButton()
        
        inviteFriendsButton.translatesAutoresizingMaskIntoConstraints = false
        inviteFriendsButton.setup(with: viewModel.inviteFriendsButtonViewModel)
        
        NSLayoutConstraint.activate([
            inviteFriendsButton.heightAnchor.constraint(equalToConstant: Constants.defaultButtonHeight)
        ])

        self.footerView = inviteFriendsButton
    }
    
    private func setupHeaderAndFooterViewsIfNeeded() {
        guard CNContactStore.authorizationStatus(for: .contacts) == .authorized else { return }
        
        setupHeaderView()
        setupFooterView()
    }
    
    // MARK: - Binding
    
    override func bindViewModel() {
        super.bindViewModel()
        
        bindToAppStateChange()
        bindToContactsToInvitePublisher()
    }

    private func bindToContactsToInvitePublisher() {
        viewModel.contactsToInvitePublisher
            .sink{ [ weak self ] contacts in
                self?.showMessageSender(contacts: contacts)
            }
            .store(in: &cancellables)
    }
    
    private func bindToAppStateChange() {
        NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification, object: nil)
            .sink { [ weak self ] _ in
                guard let self,
                      self.viewModel.contactsAuthorizationAccessStatus != CNContactStore.authorizationStatus(for: .contacts) else {
                    return
                }

                self.viewModel.contactsAuthorizationAccessStatus = CNContactStore.authorizationStatus(for: .contacts)
                self.checkContactsPermission()
            }
            .store(in: &cancellables)
    }

    // MARK: - Helpers
    
    func checkContactsPermission() {
        if CNContactStore.authorizationStatus(for: .contacts) == .notDetermined {
            CNContactStore().requestAccess(for: .contacts) { isAuthorized, error in
                self.viewModel.contactsAuthorizationAccessStatus = CNContactStore.authorizationStatus(for: .contacts)
                DispatchQueue.main.async {
                    self.setupEmptyStateView()
                    self.setupHeaderAndFooterViewsIfNeeded()
                }

                if isAuthorized {
                    self.viewModel.fetchContacts()
                } else {
                    DispatchQueue.main.async {
                        self.viewModel.dataSource.send([])
                    }
                }
            }
        } else {
            setupHeaderAndFooterViewsIfNeeded()

            if CNContactStore.authorizationStatus(for: .contacts) == .authorized {
                self.viewModel.fetchContacts()
            } else {
                DispatchQueue.main.async {
                    self.viewModel.dataSource.send([])
                }
            }
        }
    }
    
    // MARK: - UITableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.handleSelectedItemForMultipleSelection(indexPath: indexPath)
    }
    
    // MARK: - Message Compose Delegate

    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true)
    }
    
    // MARK: - Navigation
    
    private func showMessageSender(contacts: [CNContact]) {
        let messageVC = MFMessageComposeViewController()

        messageVC.body = "Hey, I'm using Sword to chat and make transactions – and so are 1 000 of our other contacts. Join us! Download it here \(Constants.AppURL.inviteFriendURL)"

        messageVC.recipients = contacts.compactMap {
            return ($0.phoneNumbers.first?.value as? CNPhoneNumber)?.stringValue
        }
        
        messageVC.messageComposeDelegate = self
        
        present(messageVC, animated: true, completion: nil)
    }
}
