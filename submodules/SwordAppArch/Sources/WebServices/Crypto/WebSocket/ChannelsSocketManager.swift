//
//  ChannelsSocketManager.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 12.04.23.
//

import Combine
import Foundation

final class ChannelsSocketManager {
    private let messagesEvent = "message"
    private var cancellables: Set<AnyCancellable> = []

    let channelItemPublisher: PassthroughSubject<ChannelItemModel, Never> = .init()

    static let main: ChannelsSocketManager = {
        struct SingletonWrapper {
            static let singleton = ChannelsSocketManager()
        }
        return SingletonWrapper.singleton
    }()
    
    private init() {
        bindToSocketConnection()
    }

    func connect(force: Bool = false) {
        SocketIOSocketManager.global.connect(force: force)
        
        SocketIOSocketManager.global.isConnected
            .sink { [ weak self ] isConnected in
                guard let self else { return }

                print("Connected and subscribed to messages")
                SocketIOSocketManager.global.emit(event: self.messagesEvent, data: [:])
            }
            .store(in: &cancellables)
    }
    
    func disconnect() {
        SocketIOSocketManager.global.disconect()
    }

    private func bindToSocketConnection() {
        SocketIOSocketManager.global.isConnected
            .sink { [ weak self ] isConnected in
                if isConnected {
                    self?.subscribeToMessages()
                }
            }
            .store(in: &cancellables)
    }
    func subscribeToMessages() {
        SocketIOSocketManager.global.subscribe(on: self.messagesEvent) { [ weak self ] data, _ in
            guard let channelInfoDict = data.first else { return }
                do {
                    let convertedData = try JSONSerialization.data(withJSONObject: channelInfoDict)
                    let info = try JSONDecoder().decode(ChannelItemModel.self, from: convertedData)

                    self?.channelItemPublisher.send(info)
                } catch {
                    print("Failed to parse socket data to channel item. error is ---- \(error)")
                }
        }
    }
}
