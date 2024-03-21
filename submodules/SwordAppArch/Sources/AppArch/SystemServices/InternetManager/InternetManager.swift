//
//  InternetManager.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 20.04.22.
//

import UIKit
import Reachability
import Combine
import Network

final class InternetManager: InternetManaging {
    let monitor = NWPathMonitor()
    private var status: NWPath.Status = .requiresConnection
    var isReachable: Bool { status == .satisfied }
    var isReachableOnCellular: Bool = true

    var internetRechabilityPublisher: CurrentValueSubject<InternetReachabilityStatus?, Never> = CurrentValueSubject(nil)

    func startNotifyer() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.status = path.status
            self?.isReachableOnCellular = path.isExpensive

            print("Status \(path.status)")
            if path.status == .satisfied {
                print("We're connected!")
                self?.internetRechabilityPublisher.send(.reachable(.cellular))
                // post connected notification
            } else {
                print("No connection.")
                self?.internetRechabilityPublisher.send(.unreachable)
                // post disconnected notification
            }
            print(path.isExpensive)
        }

        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }

    func stopNotifyer() {
        monitor.cancel()
    }
    
    func showALert(message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Connection", message: message, preferredStyle: .alert)
            
            alert.addAction(.init(title: "Ok", style: .default))
            
            UIApplication.shared.topMostViewController()?.present(alert, animated: true)
        }
    }
}
