//
//  SocketIOSocketManager.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 10.04.23.
//

import Combine
import SocketIO
import Foundation
import UIKit

final class SocketIOSocketManager {
    static let global: SocketIOSocketManager = {
        struct SingletonWrapper {
            static let singleton = SocketIOSocketManager()
        }
        return SingletonWrapper.singleton
    }()
    
    var socketManager: SocketManager
    var socket: SocketIOClient

    let status: CurrentValueSubject<SocketStatus, Never> = CurrentValueSubject(.updating)
    
    private init() {
        self.socketManager = SocketManager(socketURL: Constants.AppURL.messagingBaseURL,
                                           config: [.log(true),
                                                    .forceWebsockets(true),
                                                    .reconnects(true),
                                                    .secure(true),
                                                    .connectParams(["connect_timeout": 10000])])

        self.socket = socketManager.socket(forNamespace: "/chat")
        
        subscribeToBaseEvents()
    }
    
    var isConnected: CurrentValueSubject<Bool, Never> = CurrentValueSubject(false)
    
    var didSocketDisconected: PassthroughSubject<UInt16, Never> = PassthroughSubject()
    private(set) var subscribers: [WebSocketStream: PassthroughSubject<Any, Never>] = [:]
    
    func connect(force: Bool = false) {
        guard force || !isConnected.value else { return }

        let payload: [String: Any] = [:]

        socket.connect(withPayload: payload)
    }
    
    func disconect() {
        guard isConnected.value else { return }

        socket.disconnect()
    }

    func establishConnection() {
        socket.disconnect()
        
        self.socketManager = SocketManager(socketURL: Constants.AppURL.messagingBaseURL,
                                           config: [.log(true),
                                                    .forceWebsockets(true),
                                                    .reconnects(true),
                                                    .secure(true),
                                                    .connectParams(["connect_timeout": 5000])])

        self.socket = socketManager.socket(forNamespace: "/chat")
        
        subscribeToBaseEvents()

        connect(force: true)
    }

    func emit(event: String, data: [String: Any]) {
        guard !data.isEmpty else { return }

        socket.emit(event, data)
    }
    
    func subscribe(on event: String, callback: @escaping NormalCallback) {
        socket.on(event, callback: callback)
    }

    func subscribeToBaseEvents() {
        socket.on(clientEvent: .connect) { [ weak self ] _, _ in
            self?.status.send(.connected)
            print("--------Socket connected--------")
            self?.isConnected.send(true)
        }
        
        socket.on(clientEvent: .statusChange) { [ weak self ] _, _ in
            guard let self else { return }
            
            let isConecting = self.socket.status == .connecting
            if isConecting {
                self.status.send(.connecting)
            }
            print("--------Socket reconnected--------")
        }

        socket.on(clientEvent: .disconnect) { [ weak self ] _, _ in
            self?.status.send(.disconnected)

            print("--------Socket disconnected--------")
            self?.isConnected.send(false)
        }
        
        socket.on(clientEvent: .error) { [ weak self ] data, _ in
            self?.status.send(.error)
        }

        socket.on(clientEvent: .reconnectAttempt) { [ weak self ] _, _ in
            self?.establishConnection()
        }
    }
}

enum SocketStatus {
    case connecting
    case connected
    case disconnected
    case updating
    case error
}
