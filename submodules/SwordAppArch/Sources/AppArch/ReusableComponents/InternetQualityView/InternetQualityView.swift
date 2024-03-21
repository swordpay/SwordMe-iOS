//
//  InternetQualityView.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 24.05.23.
//

import UIKit
import Combine

public final class InternetQualityView: SetupableView {
    // MARK: - IBOutlets
    
    @IBOutlet private weak var backgroundView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    
    // MARK: - Properties
    
    private var model: InternetQualityViewModel!
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Setup UI
    
    public func setup(with model: InternetQualityViewModel) {
        self.model = model
        
        titleLabel.text = Constants.Localization.Common.connecting
        bindToSocketStatus()
        bindToNetworkState()
//        bindToIntenetQuality()
    }
    
    // MARK: - Binding
    
    private func bindToIntenetQuality() {
        InternetQualityManager.global.quality
            .receive(on: RunLoop.main)
            .sink { [ weak self ] quality in
                switch quality {
                case .unavailable:
                    self?.titleLabel.text = Constants.Localization.Common.connectionLost
                case .low:
                    self?.titleLabel.text = Constants.Localization.Common.connecting
                case .normal:
                    return 
                }
            }
            .store(in: &cancellables)
    }
    
    private func bindToNetworkState() {
        model.networkState
            .receive(on: RunLoop.main)
            .sink { [ weak self ] networkState in
                switch networkState {
                case .connecting:
                    self?.titleLabel.text = "Connecting..."
                case .updating:
                    self?.titleLabel.text = "Updating..."
                case .waitingForNetwork:
                    self?.titleLabel.text = "Waiting for network"
                case .online:
                    break
                }
            }
            .store(in: &cancellables)
    }

    private func bindToSocketStatus() {
        SocketIOSocketManager.global.status
            .receive(on: RunLoop.main)
            .sink { [ weak self ] status in
                switch status {
                case .connecting:
                    self?.titleLabel.text = "Connecting..."
                case .connected:
                    self?.titleLabel.text = "Connected"
                case .disconnected:
                    self?.titleLabel.text = "Waiting for network"
                default:
                    return
                }
            }
            .store(in: &cancellables)
    }
}
