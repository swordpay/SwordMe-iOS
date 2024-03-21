//
//  InviteFriendsViewModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 08.02.23.
//

import Combine
import Contacts
import Foundation
// MARK: - SwordChange / should be added later
//import FirebaseDynamicLinks

struct InviteFriendsViewModelInputs {
    let syncContactsService: SyncContactsServicing
}

final class InviteFriendsViewModel: BaseViewModel<InviteFriendsViewModelInputs>, DataSourced {
    var dataSource: CurrentValueSubject<[InviteFriendsSection], Never> = CurrentValueSubject([])
    
    var addedRowsInfo: TableViewUpdatingDataModel = .init(status: .insert)
    var deletedRowsInfo: TableViewUpdatingDataModel = .init(status: .deleted)
    
    var contactsAuthorizationAccessStatus = CNContactStore.authorizationStatus(for: .contacts)
    
    let textedEmptyStateViewModel: TextedEmptyStateViewModel = .init(title: Constants.Localization.Profile.inviteFriendsEmptyScreenTitle)
    let emptyStateViewModel: SystemServicePermissionAccessViewModel = SystemServicePermissionAccessViewModel(systemService: .contacts)
    let selectedParticipants: CurrentValueSubject<[MessageParticipant], Never> = CurrentValueSubject([])
    let contactsToInvitePublisher: PassthroughSubject<[CNContact], Never> = PassthroughSubject()
    
    let headerViewModel = SearchBarHeaderViewModel(placeholder: Constants.Localization.Common.users)
    var contacts: Set<CNContact> = []
    
    lazy var inviteFriendsButtonViewModel: GradientedButtonModel = {
        return GradientedButtonModel(title: Constants.Localization.Channels.inviteFriends,
                                     hasBorders: false,
                                     isActive: false,
                                     action: { [ weak self ] in
            guard let self else { return }
            
            let participants = self.selectedParticipants.value.map { "\($0.id)" }
            let selectedContacts = self.contacts.filter { participants.contains($0.identifier) }
            
            self.contactsToInvitePublisher.send(Array(selectedContacts))
        })
    }()
    
    override init(inputs: InviteFriendsViewModelInputs) {
        super.init(inputs: inputs)
        
        bindToSearchTerm()
        bindToSearchingState()
        bindToSearchCancelling()
        bindToSelectedParticipants()
    }
    
    func provideDataSource(from messageParticipants: [MessageParticipant]) {
        let unwrappedContacts = messageParticipants.sorted(by: { $0.name < $1.name })
        let groupedContacts = Dictionary(grouping: unwrappedContacts) { $0.name.first! }.sorted { $0.key < $1.key }
        
        let sections = groupedContacts.map { Section(headerModel: TitledTableHeaderAndFooterViewModel(title: String($0)),
                                                     cellModels: $1.map { InviteFriendsParticipantItemCellModel(isForMultipleSelection: true,
                                                                                                                participent: $0,
                                                                                                                isSelected: isParticipantSelected($0)) })
        }
        
        dataSource.send(sections)
    }
    
    private func tilteViewForSection(title: String) -> TitledTableHeaderAndFooterViewModel {
        return TitledTableHeaderAndFooterViewModel(title: title,
                                                   font: ThemeProvider.currentTheme.fonts.medium(ofSize: 16,
                                                                                                 family: .poppins),
                                                   backgroundColor: ThemeProvider.currentTheme.colors.lightBlue2)
    }

    func fetchContacts() {
        let store = CNContactStore()
        let keysToFetch = [ CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey, CNContactImageDataKey ]
        
        DispatchQueue.global(qos: .default).async {
            do {
                try store.enumerateContacts(with: CNContactFetchRequest.init(keysToFetch: keysToFetch as [CNKeyDescriptor]),
                                            usingBlock: { [ weak self ] (contact, pointer) -> Void in
                    guard let self else { return }
                    if !contact.givenName.isEmpty,
                       !contact.phoneNumbers.isEmpty {
                        self.contacts.insert(contact)
                    }
                })
            } catch {
                self.error.send(error)
            }

            DispatchQueue.main.async {
                self.syncContacts()
            }
        }
    }
    
    func handleSelectedItemForMultipleSelection(indexPath: IndexPath) {
        guard let cellModel = cellModel(for: indexPath) else { return }
        
        if selectedParticipants.value.contains(cellModel.participent) {
            selectedParticipants.value.removeAll(where: { $0.id == cellModel.participent.id })
            cellModel.isSelected.send(false)
        } else {
            selectedParticipants.value.append(cellModel.participent)
            cellModel.isSelected.send(true)
        }
    }
    
    func provideRedirectURL(completion: @escaping (String?) -> Void) {
        completion(nil)
        // MARK: - SwordChange / should be added later

//        guard let username = AppData.currentUserInfo?.username,
//              let link = URL(string: "https://admin-dev.swordpay.com/invite/@\(username)") else {
//            completion(nil)
//
//            return
//        }
//
//        let dynamicLinksDomainURIPrefix = "https://swordpay.page.link/invite/@\(username)"
//        guard let linkBuilder = DynamicLinkComponents(link: link,
//                                                      domainURIPrefix: dynamicLinksDomainURIPrefix) else {
//            completion(nil)
//
//            return
//        }
//
//        linkBuilder.options = .init()
//        linkBuilder.options?.pathLength = .short
//
//        linkBuilder.iOSParameters = DynamicLinkIOSParameters(bundleID: "com.sword.swordpay")
//        linkBuilder.iOSParameters?.appStoreID = "1669498402"
//        linkBuilder.androidParameters = DynamicLinkAndroidParameters(packageName: "com.sword.dev")
//
////        self.isLoading.send(true)
//        linkBuilder.shorten { url, _, error in
//            //        self?.isLoading.send(false)
//            completion(url?.absoluteString)
//        }
    }

    private func syncContacts() {
        guard !contacts.isEmpty else {
            self.provideDataSource(from: self.messageParticipants(from: Array(self.contacts)))

            return
        }
     
        let phoneNumbers = contacts.compactMap { $0.phoneNumbers.first?.value.stringValue }
        let route = SyncContactsParams(contactsPhoneNumbers: phoneNumbers)
        
        isLoading.send(true)
        
        inputs.syncContactsService.fetch(route: route)
            .receive(on: RunLoop.main)
            .sink { [ weak self ] completion in
                self?.isLoading.send(false)
                if case let .failure(error) = completion {
                    self?.error.send(error)
                }
            } receiveValue: { [ weak self ] response in
                self?.filterExistingContact(phoneNumbers: response.phoneNumbers)
            }
            .store(in: &cancellables)
    }

    private func filterExistingContact(phoneNumbers: [String]) {
        self.contacts = contacts.filter {
            guard let phoneNumber = $0.phoneNumbers.first?.value.stringValue else { return false }
            
            return phoneNumbers.contains(phoneNumber)
        }
        
        self.provideDataSource(from: self.messageParticipants(from: Array(self.contacts)))
    }
    
    // MARK: - Binding
    
    private func bindToSearchTerm() {
        headerViewModel.searchTerm
            .sink { [ weak self ] term in
                guard let self else { return }
                
                guard let term,
                      !term.isEmpty else {
                    self.provideDataSource(from: self.messageParticipants(from: Array(self.contacts)))
                    
                    return
                }
                
                let filteredContacts = self.contacts.filter { "\($0.givenName) \($0.familyName)".lowercased().contains(term.lowercased()) }
                self.provideDataSource(from: self.messageParticipants(from: Array(filteredContacts)))
            }
            .store(in: &cancellables)
    }
    
    private func bindToSearchCancelling() {
        headerViewModel.searchCancelPublisher
            .sink { [ weak self ] in
                guard let self else { return }
                
                self.provideDataSource(from: self.messageParticipants(from: Array(self.contacts)))
            }
            .store(in: &cancellables)
    }
    
    private func bindToSearchingState() {
        headerViewModel.isSearchActive
            .sink { [ weak self ] isActive in
                guard let self else { return }

                let title = isActive || self.headerViewModel.hasTerm ? Constants.Localization.Channels.pickerEmptyStateTitle
                                     : Constants.Localization.Common.errorMessage
                self.textedEmptyStateViewModel.title.send(title)
            }
            .store(in: &cancellables)
    }

    private func bindToSelectedParticipants() {
        selectedParticipants
            .map { !$0.isEmpty }
            .sink { [ weak self ] areThereSelectedParticipants in
                self?.inviteFriendsButtonViewModel.isActive.send(areThereSelectedParticipants)
            }
            .store(in: &cancellables)
    }
    
    private func isParticipantSelected(_ participant: MessageParticipant) -> Bool {
        return selectedParticipants.value.first(where: { $0.id == participant.id } ) != nil
    }
    
    private func messageParticipants(from contacts: [CNContact]) -> [MessageParticipant] {
        return contacts.map { contact in
            return MessageParticipant(id: contact.identifier,
                                      name: "\(contact.givenName) \(contact.familyName)",
                                      image: contact.imageData)
        }
    }
}
