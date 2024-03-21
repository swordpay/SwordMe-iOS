//
//  InternetQualityManager.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 24.05.23.
//

import Combine
import Foundation

final class InternetQualityManager {
    private var cancellables: Set<AnyCancellable> = []
    private var expirationTimer: Timer?
    private var lowStateCount = 0

    static let global: InternetQualityManager = {
        struct SingletonWrapper {
            static let singleton = InternetQualityManager()
        }
        return SingletonWrapper.singleton
    }()
    
    var quality: CurrentValueSubject<InternetQuality, Never>  = .init(.normal)
    
    init() {
        bindToInternetConnectionState()
    }
    
    func startMonitoring() {
        expirationTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { [ weak self ] timer in
            guard let self else { return }
            
            self.checkInternetConnectionQuality()
        })
    }
    
    func stopMonitoring() {
        expirationTimer?.invalidate()
        expirationTimer = nil
    }

    func checkInternetConnectionQuality() {
        let url = URL(string: "https://api-dev.swordpay.com/v1/ping")!
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForResource = 1.5
        let session = URLSession(configuration: sessionConfig)

        let task = session.dataTask(with: url) { [ weak self ] (_, response, error) in
        
            if let error = error as? NSError, error.code == NSURLErrorTimedOut {
                print("Error: \(error.localizedDescription)")
                self?.handleLowState()

                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                print("Invalid response")
                
                self?.quality.send(.unavailable)

                return
            }

            self?.handleNormalStatus()
            self?.resetLowStateInfo()
        }

        task.resume()
    }

    private func handleNormalStatus() {
        guard quality.value != .normal else { return }
        
        quality.send(.normal)
        SocketIOSocketManager.global.establishConnection()
    }

    private func handleLowState() {
        lowStateCount += 1

        if lowStateCount >= 5 {
            quality.send(.unavailable)
        } else {
            quality.send(.low)
        }
    }
    
    private func resetLowStateInfo() {
        lowStateCount = 0
    }

    private func bindToInternetConnectionState() {
        InternetManagerProvider.reachability.internetRechabilityPublisher
            .sink { [ weak self ] status in
                if let status, case .reachable = status {
//                    self?.quality.send(.normal)
                    self?.startMonitoring()
                } else {
                    self?.stopMonitoring()
//                    self?.quality.send(.unavailable)
                }
            }
            .store(in: &cancellables)
    }
}

public enum InternetQuality {
    case low
    case normal
    case unavailable
}

public enum NetworkState {
    case waitingForNetwork
    case connecting
    case updating
    case online
}
