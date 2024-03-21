//
//  ChannelItemCellModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 20.12.22.
//

import Combine
import Foundation

final class ChannelItemCellModel {
    private let downloadManager: DataDownloadManaging
    private var cancellables: Set<AnyCancellable> = []

    let channel: CurrentValueSubject<ChannelItemModel, Never>
    
    let channelImageSetupModel: TextPlaceholderedImageViewModel
    
    var lastMessageSender: String? {
        return channel.value.lastMessage?.sender.fullName
    }

    var lastMessage: String? {
        return channel.value.lastMessage?.content
    }

    var formattedDate: String? {
        return channel.value.lastMessage?.date.toCommonFormattedDate(currnetFormat: Constants.DateFormat.yyyymmdd_dashed)
    }
    
    var channelImageURL: URL? {
        guard let path = channel.value.presentableChannelImagePath else { return nil }
        
        return URL(string: path)
    }

    init(channel: ChannelItemModel,
         downloadManager: DataDownloadManaging) {
        self.channel = .init(channel)
        self.downloadManager = downloadManager
        self.channelImageSetupModel = .init(imageData: nil,
                                            title: channel.presentableName?.first?.uppercased() ?? "",
                                            fontSize: 24,
                                            cornerRadius: 6)
    }
    
    func prepareChannelImagePhoto() {
        guard let channelImageURL  else {
            channelImageSetupModel.imageData.send(nil)
            
            return
        }

        downloadManager.download(from: channelImageURL)
            .receive(on: RunLoop.main)
            .sink { [ weak self ] completion in
                switch completion {
                case .failure(_):
                    self?.channelImageSetupModel.imageData.send(nil)
                default:
                    return
                }
            } receiveValue: { [ weak self ] data in
                self?.channelImageSetupModel.imageData.send(data)
            }
            .store(in: &cancellables)
    }

    func cancelChannelImageDownload() {
        guard let channelImageURL else { return }
        
        downloadManager.cancelDownloading(for: channelImageURL)
    }
}
