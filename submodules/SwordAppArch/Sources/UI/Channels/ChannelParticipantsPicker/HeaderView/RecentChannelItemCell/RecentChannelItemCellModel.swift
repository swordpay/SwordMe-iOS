//
//  RecentChannelItemCellModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 27.03.23.
//

import Combine
import Foundation

final class RecentChannelItemCellModel {
    private let downloadManager: DataDownloadManaging
    private var cancellables: Set<AnyCancellable> = []

    static let cellIdentifier = "\(RecentChannelItemCell.self)"
    
    let channelItem: ChannelItemModel
    let channelImageSetupModel: TextPlaceholderedImageViewModel

    private var channelImageURL: URL? {
        guard let path = channelItem.presentableChannelImagePath else { return nil }
        
        return URL(string: path)
    }

    init(channelItem: ChannelItemModel,
         downloadManager: DataDownloadManaging) {
        self.channelItem = channelItem
        self.channelImageSetupModel = .init(imageData: nil,
                                            title: channelItem.presentableName ?? "",
                                            fontSize: 17,
                                            cornerRadius: 30)
        self.downloadManager = downloadManager
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
