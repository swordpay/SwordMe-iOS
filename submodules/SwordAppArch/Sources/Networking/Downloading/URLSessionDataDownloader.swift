//
//  URLSessionDataDownloader.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 13.04.22.
//

import Foundation
import Combine

public final class URLSessionDataDownloader: DataDownloading {
    private let queue = DispatchQueue(label: Constants.AppLabel.dataDownloaderIdentifier, attributes: .concurrent)
    private var cancellables: [URL: AnyCancellable] {
        var cancellablesCopy: [URL: AnyCancellable] = [:]

        queue.sync {
            cancellablesCopy = self.unsafeCancellables
        }
        
        return cancellablesCopy
    }

    private var pendingPublishers: Dictionary<URL, [PassthroughSubject<Data, Error>]> = [:]
    private var unsafeCancellables: [URL: AnyCancellable] = [:]

    public func download(from url: URL) -> AnyPublisher<Data, Error> {
        if cancellables[url] != nil {
            let subject = PassthroughSubject<Data, Error>()

            addPendingPublisher(subject, for: url)

            return subject.eraseToAnyPublisher()
        } else {
            return Future { [ weak self ] promise in
                let cancellable = URLSession.shared
                    .dataTaskPublisher(for: url)
                    .map { $0.data }
                    .mapError(DataDownloadError.general)
                    .sink { completion in
                        switch completion {
                        case .failure(let error):
                            promise(.failure(error))
                        default:
                            break
                        }
                    } receiveValue: { data in
                        promise(.success(data))
                        self?.notifyPendingPublishers(for: url, with: data)
                    }

                self?.queue.async(flags: .barrier) {
                    self?.unsafeCancellables[url] = cancellable
                }
            }
            .eraseToAnyPublisher()
        }
    }

    public func cancelDownloading(for url: URL) {
        queue.async(flags: .barrier) { [ weak self ] in
            self?.pendingPublishers.removeValue(forKey: url)
            let task = self?.unsafeCancellables.removeValue(forKey: url)
            task?.cancel()
        }
    }

    // MARK: - Private API

    private func addPendingPublisher(_ publisher: PassthroughSubject<Data, Error>, for url: URL) {
        var publishers = pendingPublishers[url] ?? []

        publishers.append(publisher)
        pendingPublishers[url] = publishers
    }
    
    private func notifyPendingPublishers(for url: URL, with data: Data) {
        pendingPublishers[url]?.forEach { $0.send(data) }
        pendingPublishers.removeValue(forKey: url)
    }
}
