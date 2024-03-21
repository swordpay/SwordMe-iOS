//
//  ChannelParticipantsPickerViewModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 21.12.22.
//

import UIKit
import Combine
import TelegramCore
import AccountContext
import SwiftSignalKit

struct ChannelParticipantsPickerViewModelInputs {
    let createChannelService: CreateChannelServicing
    let getAllUsersService: GetAllUsersServicing
    let getLatestPaymentsService: GetLatestPaymentsServicing
}

final class ChannelParticipantsPickerViewModel: BaseViewModel<ChannelParticipantsPickerViewModelInputs>, DataSourced {
    typealias Section = ChannelParticipantsPickerSection
    var dataSource: CurrentValueSubject<[ChannelParticipantsPickerSection], Never> = .init([])
    
    var addedRowsInfo: TableViewUpdatingDataModel = .init(status: .insert)
    var deletedRowsInfo: TableViewUpdatingDataModel = .init(status: .deleted)

    let accountContext: AccountContext
    private var peers: [EnginePeer] = []
    private let contactPeersViewPromise = Promise<(EngineContactList, EnginePeer?)>()
    private var contactsDisposable: Disposable?

    private let mainPeer: ChannelsHeaderViewModel.Info

    var selectedParticipants: CurrentValueSubject<[ChannelsHeaderViewModel.Info], Never>
    let chatItemPublisher: PassthroughSubject<ChannelItemModel, Never> = PassthroughSubject()
    let createChannelCompletion: PassthroughSubject<ChannelItemModel, Never> = PassthroughSubject()
    let openPaymentScreenPublisher: PassthroughSubject<PayOrRequestStateInfoModel, Never> = PassthroughSubject()
    
    let isForMultipleSelection: Bool
    let emptyStateModel: TextedEmptyStateViewModel = .init(title: Constants.Localization.Common.errorMessage)
    let groupChannelPublisher: PassthroughSubject<[ChannelUserModel], Never> = .init()
    let additionalPeersPublisher: PassthroughSubject<[ChannelsHeaderViewModel.Info], Never> = .init()
        
    lazy var headerSetupModel = ChannelParticipantsPickerHeaderViewModel(source: source,
                                                                         searchBarSetupModel: searchBarSetupModel,
                                                                         initialPeers: selectedParticipants.value)
    
    let searchBarSetupModel = SearchBarHeaderViewModel(placeholder: Constants.Localization.Common.users)
    let source: ChannelParticipantsPickerSource
    private var searchTerm: String? = nil
    
    init(inputs: ChannelParticipantsPickerViewModelInputs,
         accountContext: AccountContext,
         isForMultipleSelection: Bool,
         source: ChannelParticipantsPickerSource,
         mainPeer: ChannelsHeaderViewModel.Info,
         addedPeers: [ChannelsHeaderViewModel.Info]) {
        self.isForMultipleSelection = isForMultipleSelection
        self.source = source
        self.accountContext = accountContext
        self.selectedParticipants = .init(addedPeers)
        self.mainPeer = mainPeer
        
        super.init(inputs: inputs)
        
        bindToSearchTerm()
        bindToSearchingState()
        bindToSearchCancelling()
        bindToHeaderModelDeletedItem()
        
        self.contactPeersViewPromise.set(self.accountContext.engine.data.subscribe(
            TelegramEngine.EngineData.Item.Contacts.List(includePresences: false),
            TelegramEngine.EngineData.Item.Peer.Peer(id: self.accountContext.engine.account.peerId)
        )
        |> mapToThrottled { next -> Signal<(EngineContactList, EnginePeer?), NoError> in
            return .single(next)
            |> then(
                .complete()
                |> delay(5.0, queue: Queue.concurrentDefaultQueue())
            )
        })

        self.contactsDisposable = self.contactPeersViewPromise.get()
            .start(next: { [ weak self ]  (engineContactList: EngineContactList, _) in
                guard let self else { return }
                self.peers = engineContactList.peers.filter { $0.id != self.accountContext.account.peerId  && $0.id != mainPeer.enginePeer.id }
                
                self.prepareDataSource(peers: self.peers)
            })
    }
    
    deinit {
        contactsDisposable?.dispose()
    }

    private func prepareDataSource(peers: [EnginePeer]) {
        guard !peers.isEmpty else {
            dataSource.send([])
            
            return
        }

        let cellModels: [ChannelParticipantsPickerCellModel] = peers.map {
            let isSelected = selectedParticipants.value.map { $0.enginePeer.id }.contains($0.id)
            
            return .init(isForMultipleSelection: true,
                         participent: .init(enginePeer: $0, account: accountContext.account, context: accountContext, theme: accountContext.sharedContext.currentPresentationData.with { $0 }.theme, synchronousLoads: true, peerPresenceState: .online),
                         isSelected: isSelected) }
        
        updateDataSource(cellModels: cellModels)
    }
    
    private func updateDataSource(cellModels: [ChannelParticipantsPickerCellModel]) {
        self.dataSource.send([.init(headerModel: configureHeaderViewModel(title: ""),
                                    cellModels: cellModels)])
    }
    
    func preparePayOrRequestStateInfo(channelInfo: ChannelItemModel? = nil, participants: [ChannelUserModel] = []) -> PayOrRequestStateInfoModel {
        return .init(peerId: nil,
                     source: .createPayment,
                     isRequesting: true,
                     channelInfo: channelInfo,
                     requestInfo: nil)
    }
    
    func handleSelectedItem(at indexPath: IndexPath) {
        handleSelectedItemForMultipleSelection(indexPath: indexPath)
    }
        
    private func handleSelectedItemForMultipleSelection(indexPath: IndexPath) {
        guard let cellModel = cellModel(for: indexPath) else { return }
        let selectedPeerIds = selectedParticipants.value.map { $0.enginePeer.id }
        if selectedPeerIds.contains(cellModel.participent.enginePeer.id) {
            selectedParticipants.value.removeAll(where: { $0.enginePeer.id == cellModel.participent.enginePeer.id })
            cellModel.isSelected.send(false)
            headerSetupModel.deleteParticipant(cellModel.participent)
        } else {
            selectedParticipants.value.append(cellModel.participent)
            cellModel.isSelected.send(true)
            headerSetupModel.addingParticipant.send(cellModel.participent)
        }
    }
    
    func createChannel() {
        guard let route = prepareRouteForChannelCreation() else { return }
        
        isLoading.send(true)
        
        inputs.createChannelService.fetch(route: route)
            .receive(on: RunLoop.main)
            .sink { [ weak self ] completion in
                self?.isLoading.send(false)
                if case let .failure(error) = completion {
                    self?.error.send(error)
                }
            } receiveValue: { [ weak self ] response in
                NotificationCenter.default.post(name: .channelsInfoDidChange, object: nil)
                self?.createChannelCompletion.send(response.data)
            }
            .store(in: &cancellables)
    }

    private func prepareRouteForChannelCreation() -> CreateChannelRouting? {
//        let participants = selectedParticipants.value
        
        return nil
    }
    
    private func configureHeaderViewModel(title: String) -> TitledTableHeaderAndFooterViewModel {
        return TitledTableHeaderAndFooterViewModel(title: title,
                                                   font: ThemeProvider.currentTheme.fonts.semibold(ofSize: 16,
                                                                                                  family: .poppins),
                                                   textAlignment: .left,
                                                   backgroundColor: .clear)
    }

    // MARK: - Binding
    
    private func bindToSearchTerm() {
        searchBarSetupModel.searchTerm
            .dropFirst()
            .debounce(for: .seconds(0.25), scheduler: DispatchQueue.global())
            .sink { [ weak self ] term in
                guard let self else { return }

                guard let term,
                      !term.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                    self.searchTerm = nil
                    self.prepareDataSource(peers: self.peers)

                    return
                }
                
                self.searchTerm = term
                let filteredPeers = self.peers.filter { $0.indexName.stringRepresentation(lastNameFirst: false, separator: " ").lowercased().contains(term.lowercased()) }
                
                self.prepareDataSource(peers: filteredPeers)
            }
            .store(in: &cancellables)
    }
    
    private func bindToSearchCancelling() {
        searchBarSetupModel.searchCancelPublisher
            .sink { [ weak self ] in
                guard let self else { return }
                
                self.searchTerm = nil
                self.prepareDataSource(peers: self.peers)
            }
            .store(in: &cancellables)
    }

    private func bindToSearchingState() {
        searchBarSetupModel.isSearchActive
            .sink { [ weak self ] isActive in
                guard let self else { return }

                let title = isActive || self.searchBarSetupModel.hasTerm ? Constants.Localization.Channels.pickerEmptyStateTitle
                                     : Constants.Localization.Common.errorMessage
                self.emptyStateModel.title.send(title)
            }
            .store(in: &cancellables)
    }

    private func bindToHeaderModelDeletedItem() {
        headerSetupModel.deletedParticipantPublisher
            .sink { [ weak self ] participant in
                guard let self else { return }
                
                self.selectedParticipants.value.removeAll(where: { $0.enginePeer.id == participant.enginePeer.id })

                guard let indexPath = self.indexPath(for: participant),
                      let cellModel = self.cellModel(for: indexPath) else { return }
                
                cellModel.isSelected.send(false)
            }
            .store(in: &cancellables)
    }

    // MARK: - Helpers
    
    private func isParticipantSelected(_ participant: Constants.Typealias.PeerExtendedInfo) -> Bool {
        return selectedParticipants.value.map{ $0.enginePeer.id }.contains(participant.enginePeer.id)
    }
    
    private func indexPath(for participant: Constants.Typealias.PeerExtendedInfo) -> IndexPath? {
        guard let first = dataSource.value.first?.cellModels.firstIndex(where: {$0.participent.enginePeer.id == participant.enginePeer.id }) else { return nil }
        
        return IndexPath(row: Int(first), section: 0)
    }
}
