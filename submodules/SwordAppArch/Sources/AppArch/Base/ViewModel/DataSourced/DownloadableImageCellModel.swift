//
//  DownloadableImageCellModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 21.06.22.
//

import Combine
import Foundation

class DownloadableImageCellModel {
    var cancellables: Set<AnyCancellable> = []

    var imagePath: String? { return nil }
    var imagePublisher: PassthroughSubject<Data?, Never> = PassthroughSubject()
    var downloadManager: DataDownloadManaging

    var placeholderImageName: String? { return nil }

    init(downloadManager: DataDownloadManaging) {
        self.downloadManager = downloadManager
    }

    func prepareImage() {
        guard let path = imagePath,
              !path.isEmpty,
              let url = URL(string: path) else {
            imagePublisher.send(nil)

            return
        }

        downloadManager.download(from: url)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {[ weak self ] completion in
                switch completion {
                case .failure(_):
                    self?.imagePublisher.send(nil)
                default:
                    break
                }
            }) { [ weak self ] data in
                self?.imagePublisher.send(data)
            }
            .store(in: &cancellables)
    }

    func cancelImageDownloading() {
        guard let imagePath = imagePath,
              let url = URL(string: imagePath) else { return }

        downloadManager.cancelDownloading(for: url)
    }
}
