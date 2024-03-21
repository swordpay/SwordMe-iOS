//
//  ChannelsHeaderItemCellModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 04.05.23.
//

import Foundation
import TelegramCore

final class ChannelsHeaderItemCellModel {
    let channelItem: ChannelsHeaderViewModel.Info
    static let cellIdentifier = "\(ChannelsHeaderItemCell.self)"

//    var channelImageURL: URL? {
//        guard let path = channelItem.presentableChannelImagePath,
//              let url = URL(string: path) else { return nil }
//        
//        return url
//    }
    
    init(channelItem: ChannelsHeaderViewModel.Info) {
        self.channelItem = channelItem
    }
}
