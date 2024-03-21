//
//  ChannelsActionsBottomViewModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 06.04.23.
//

import Combine
import Foundation

public final class ChannelsActionsBottomViewModel {
    public let payOrRequestButtonPublisher: PassthroughSubject<Void, Never> = PassthroughSubject()
    public let isForChannels: Bool
    public var isSendActionAvailable: Bool = true
    
    public var viewHeight: CGFloat {
        return ComponentSizeProvider.sendOrReqeustButtonHeight.size + 24
    }

    public init(isForChannels: Bool = true) {
        self.isForChannels = isForChannels
    }
}
