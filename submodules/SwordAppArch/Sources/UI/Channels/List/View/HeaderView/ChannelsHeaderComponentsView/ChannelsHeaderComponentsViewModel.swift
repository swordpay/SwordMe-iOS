//
//  ChannelsHeaderComponentsViewModel.swift
//  SwordAppArch
//
//  Created by Tigran Simonyan on 04.10.23.
//

import Combine
import Foundation

public final class ChannelsHeaderComponentsViewModel {
    public let channelsHeaderViewModel: ChannelsHeaderViewModel
    
    public let transactionsTapHandler: PassthroughSubject<Void, Never> = .init()
    
    public init(channelsHeaderViewModel: ChannelsHeaderViewModel) {
        self.channelsHeaderViewModel = channelsHeaderViewModel
    }
}
