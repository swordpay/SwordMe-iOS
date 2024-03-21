//
//  ChannelsViewModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 20.12.22.
//

import UIKit
import Combine
import LocalAuthentication

protocol HapticFeedbackGeneratable {
    func pushHapticFeedback()
}

extension HapticFeedbackGeneratable {
    func pushHapticFeedback() {
        let generator = UINotificationFeedbackGenerator()

        generator.notificationOccurred(.error)
    }
}

struct ChannelsViewModelInputs {
    let downloadManager: DataDownloadManaging
    let getUserService: GetUserServicing
    let getChannelsService: GetChannelsServicing
    let getUserByUsernameService: GetUserByUsernameServicing
    let deleteChannelService: DeleteChannelServicing
}

final class ChannelsViewModel: InfiniteDataSourcedViewModel<ChannelsViewModelInputs, ChannelsSection, GetChannelsResponse>, BiometricAuthenticationManager, HapticFeedbackGeneratable {
    var context: LAContext = LAContext()
    override var hasRefreshableContent: Bool { return true }
    var channelsInfoDidChange = false
    
    let emptyStateViewModel: ChannelsEmptyStateViewModel = .init()
    let cellToMoveToTopIndexPath: PassthroughSubject<IndexPath, Never> = PassthroughSubject()
    
    let selectedChannel: PassthroughSubject<ChannelItemModel, Never> = PassthroughSubject()
    let headerModel: CurrentValueSubject<ChannelsHeaderViewModel?, Never> = .init(nil)
    
    var isFetchingNewChannels: Bool = false
    var isBatchUpdating: Bool = false

    var userFetchingCompletionPublisher: PassthroughSubject<Void, Never> = PassthroughSubject()

    private var appInactivingDate: Date?
    private var pendingChannelsFromSocket: [ChannelItemModel] = []
    
    override init(inputs: ChannelsViewModelInputs) {
        super.init(inputs: inputs)
        
        bindToChannelUpdate()
        bindToAppStateNotification()
        bindToChatDismissNotifiction()
        bindToChannelsInfoChangingNotification()
        
        setupChannelsUpdate()
    }
    
    func removeChannel(at indexPath: IndexPath, completion: @escaping (Bool) -> Void) {
        guard let cellModel = self.cellModel(for: indexPath) else {
            completion(false)
            
            return
        }
        
        isLoading.send(true)
        
        inputs.deleteChannelService.fetch(route: .init(channelId: cellModel.channel.value.id))
            .receive(on: RunLoop.main)
            .sink { [ weak self ] result in
                self?.isLoading.send(false)
                if case .failure = result {
                    print("Failed to delete channel")
                    completion(false)
                }
            } receiveValue: { [ weak self ] response in
                guard let self else { return }
                
                let isDeleted = response.data.success
                
                completion(isDeleted)
                if isDeleted,
                   var existingDataSource = self.dataSource.value.first?.cellModels,
                   !existingDataSource.isEmpty {
                    self.deletedRowsInfo.indexPaths = [indexPath]
                    existingDataSource.remove(at: indexPath.row)
                    self.dataSource.send([.init(cellModels: existingDataSource)])
                }
            }
            .store(in: &cancellables)
    }

    func getUserInfo() {
        isLoading.send(true)
        
        let route = GetUserParams()
        
        inputs.getUserService.fetch(route: route)
            .receive(on: RunLoop.main)
            .sink { [ weak self ] completion in
                if case let .failure(error) = completion {
                    self?.isLoading.send(false)
                    self?.logout()
                    print("error \(error.localizedDescription)")
                } else {
                    AppData.isRegistredUserExists = true
                    self?.tryToEnableBiometricAuthentication()
                }
            } receiveValue: { [ weak self ] response in
                AppData.currentUserInfo = response.user
                self?.prepareRecentChannels()
                self?.prepareContent(fetchingType: .refresh)
                self?.userFetchingCompletionPublisher.send(())
            }.store(in: &cancellables)
    }

    private func prepareRecentChannels() {
        let route = GetChannelsParams(type: .direct, hasAvatar: true, limit: 10)
        
        inputs.getChannelsService.fetch(route: route)
            .receive(on: RunLoop.main)
            .sink { [ weak self ] completion in
                self?.isLoading.send(false)
                if case let .failure(error) = completion {
                    print("Recents channels fetching failed. Error \(error)")
                }
            } receiveValue: { [ weak self ] response in
                guard !response.channels.isEmpty else { return }
                
                let headerModel = ChannelsHeaderViewModel(recentChannels: [])
                
                self?.headerModel.send(headerModel)
                self?.bindToHeaderModel(headerModel)
            }
            .store(in: &cancellables)
    }
    
    private func updateChannelsIfNeeded() {
        guard let appInactivingDate else { return }
        
        let formatedDate = appInactivingDate.formatedDateWithoutTimeZone(by: Constants.DateFormat.yyyymmdd_dashed_withoutTimezone)
        isFetchingNewChannels = true
        let params = GetChannelsParams(afterDate: formatedDate)
        
        inputs.getChannelsService.fetch(route: params)
            .receive(on: RunLoop.main)
            .sink { [ weak self ] completion in
                self?.isLoading.send(false)
                self?.isFetchingNewChannels = false
                if case let .failure(error) = completion {
                    print("Updated channels fetching failed. Error \(error)")
                }
            } receiveValue: { [ weak self ] response in
                self?.updateChannels(response)
            }
            .store(in: &cancellables)
    }
    
    private func bindToHeaderModel(_ headerModel: ChannelsHeaderViewModel) {
//        headerModel.selectedChannel
//            .sink { [ weak self ] channel in
//                self?.selectedChannel.send(channel)
//            }
//            .store(in: &cancellables)
    }

    // MARK: - Data Sourece Provider
    
    override func provideContentPublisher(fetchingType: FetchingType = .default) -> AnyPublisher<GetChannelsResponse, Error> {
        var lastRoomId: Int? = nil
        
        if fetchingType == .refresh {
            lastRoomId = nil
        } else {
            if let lastItemIndexPath = self.lastItemIndexPath(),
               let lastItemCell = cellModel(for: lastItemIndexPath) {
                lastRoomId = lastItemCell.channel.value.id
            }
        }
        
        let route = GetChannelsParams(afterChannelId: lastRoomId, limit: limit)
        
        return inputs.getChannelsService.fetch(route: route)
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }

    override func cellModel(from response: GetChannelsResponse) -> [ChannelItemCellModel] {
        return response.channels.map { .init(channel: $0, downloadManager: inputs.downloadManager) }
    }

    override func section(from cellModels: [ChannelItemCellModel]) -> ChannelsSection {
        return .init(cellModels: cellModels)
    }

    func tryToEnableBiometricAuthentication() {
        guard AppData.isBiometricAuthenticationEnabled == nil else { return }
        
        if self.askBiometricAuthenticationPermission() {
            performBiometricAuthentication(policy: .deviceOwnerAuthentication) { success in
                AppData.isBiometricAuthenticationEnabled = success
            }
        }
    }

    private func updateChannels(_ response: GetChannelsResponse) {
        guard !response.channels.isEmpty else { return }
        
        insertNewChannels(response)
    }

    private func insertNewChannels(_ response: GetChannelsResponse) {
        let newCellModels = cellModel(from: response)
        let newChannelsIds = response.channels.map { $0.id }
        let exsistingCells = (dataSource.value.first?.cellModels ?? []).filter { !newChannelsIds.contains($0.channel.value.id) }

        let newSection = section(from: newCellModels + exsistingCells)
        
        dataSource.send([newSection])
    }

    func addPendingChannels() {
        for channel in pendingChannelsFromSocket {
            if !isBatchUpdating {
                handleNewChannelItem(channel)
                pendingChannelsFromSocket.removeAll(where: { $0.id == channel.id })
            }
        }
    }

    private func setupChannelsUpdate(force: Bool = false) {
        SocketIOSocketManager.global.establishConnection()
    }
    
    private func handleNewChannelInfo(_ channelInfo: ChannelItemModel) {
        
        isBatchUpdating = true
        
        guard let section = dataSource.value.first else {
            let newSection = ChannelsSection(cellModels: [ChannelItemCellModel(channel: channelInfo, downloadManager: inputs.downloadManager)])
            
            dataSource.send([newSection])
            
            return
        }

        guard let existingCellIndex = section.cellModels.firstIndex(where: { $0.channel.value.id == channelInfo.id }) else {
            addedRowsInfo.indexPaths = [IndexPath(row: 0, section: 0)]
            section.cellModels.insert(.init(channel: channelInfo,
                                            downloadManager: inputs.downloadManager), at: 0)
            dataSource.send([section])
            
            return
        }
        
        dataSource.value.first?.cellModels[safe: Int(existingCellIndex)]?.channel.send(channelInfo)

        guard existingCellIndex != 0 else {
            isBatchUpdating = false

            return
        }
        
        moveToTopCellModel(at: Int(existingCellIndex))
        cellToMoveToTopIndexPath.send(.init(row: Int(existingCellIndex), section: 0))
        isBatchUpdating = false
    }
    
    private func moveToTopCellModel(at index: Int) {
        guard let deletedCellModel = dataSource.value.first?.cellModels.remove(at: index) else { return }

        dataSource.value.first?.cellModels.insert(deletedCellModel, at: 0)
    }

    // MARK: - Binding
    
    private func bindToChannelsInfoChangingNotification() {
        NotificationCenter.default.publisher(for: .channelsInfoDidChange)
            .sink { [ weak self ] _ in
                self?.channelsInfoDidChange = true
            }
            .store(in: &cancellables)
    }

    private func bindToChatDismissNotifiction() {
        NotificationCenter.default.publisher(for: .chatScreenDidDismiss)
            .sink { [ weak self ] _ in
                self?.prepareContent(fetchingType: .refresh)
            }
            .store(in: &cancellables)
    }
    
    private func bindToChannelUpdate() {
        ChannelsSocketManager.main.channelItemPublisher
            .receive(on: RunLoop.main)
            .sink { [ weak self ] channelInfo in
                guard let self else { return }
                
                guard !self.isFetchingNewChannels && !self.isBatchUpdating else {
                    if !self.pendingChannelsFromSocket.contains(where: {
                        $0.lastMessage?.id == channelInfo.lastMessage?.id && channelInfo.lastMessage?.id != nil
                    }) {
                        print("MEssage added to pending")
                        self.pendingChannelsFromSocket.append(channelInfo)
                    }

                    return
                }

                self.handleNewChannelItem(channelInfo)
            }
            .store(in: &cancellables)
    }
    
    private func handleNewChannelItem(_ channel: ChannelItemModel) {
        handleNewChannelInfo(channel)
        notifyAccountsInfoUpdateIfNeeded(for: channel.lastMessage)
        prepareRecentChannels()
    }

    private func bindToAppStateNotification() {
        NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)
            .sink { [ weak self ] _ in
                self?.updateChannelsIfNeeded()
                self?.setupChannelsUpdate(force: true)
            }
            .store(in: &cancellables)

        NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)
            .sink { [ weak self ] _ in
                self?.appInactivingDate = Date()
                ChannelsSocketManager.main.disconnect()
            }
            .store(in: &cancellables)
            
        InternetManagerProvider.reachability.internetRechabilityPublisher
            .sink { [ weak self ] status in
                if let status, case .reachable = status {
                    self?.updateChannelsIfNeeded()
                    self?.setupChannelsUpdate(force: true)
                } else {
                    self?.appInactivingDate = Date()
                }
            }
            .store(in: &cancellables)
        
        SocketIOSocketManager.global.status
            .removeDuplicates()
            .sink { [ weak self ] status in
                guard status != .error else { return }

                if status == .connected {
                    self?.updateChannelsIfNeeded()
                } else {
                    self?.appInactivingDate = Date()
                }
            }
            .store(in: &cancellables)
    }

    // MARK: - Account info handler
    
    private func notifyAccountsInfoUpdateIfNeeded(for message: ChannelMessageModel?) {
        guard let message else { return }
                
        guard let paymentTransaction = message.paymentTransaction,
              paymentTransaction.status == .completed else { return }

        NotificationCenter.default.post(name: .accountInfoDidChange, object: self)
        NotificationCenter.default.post(name: .cryptoAccountInfoDidChange, object: self)
    }
    
    // MARK: - Local notification
    
    private func showLocalNotificationIfNeeded(for channel: ChannelItemModel) {
//        guard !isInRecievedMessageChannel(channel) else { return }
        
        let title: String
        let subtitle: String
       
        if let message = channel.lastMessage {
            title = Constants.Localization.LocalNotification.newMessageTitle
            subtitle = message.content
        } else {
            title = Constants.Localization.LocalNotification.newChannelTitle
            subtitle = Constants.Localization.LocalNotification.newChannelSubTitle
        }

        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        if let data = try? JSONEncoder().encode(channel),
           let object = try? JSONSerialization.jsonObject(with: data) {
            content.userInfo = ["key": "ROOM_MESSAGES",
                                "alert": ["title": title, "subTitle": subtitle, "body": subtitle],
                                "data": object]
        }

        // show this notification five seconds from now
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)

        // choose a random identifier
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }
    
    private func isInRecievedMessageChannel(_ channelModel: ChannelItemModel) -> Bool {
        guard channelModel.lastMessage?.sender.username != AppData.currentUserInfo?.username else { return true }
        
        return true
    }
}
