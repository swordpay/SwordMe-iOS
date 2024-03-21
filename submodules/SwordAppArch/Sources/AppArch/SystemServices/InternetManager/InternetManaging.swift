//
//  InternetManaging.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 20.04.22.
//

import Foundation
import Combine

enum InternetReachabilityStatus: Equatable {
    case reachable(InternetReachabilityType)
    case unreachable
}

enum InternetReachabilityType: Equatable {
    case wifi
    case cellular
}

protocol InternetManaging {
    var internetRechabilityPublisher: CurrentValueSubject<InternetReachabilityStatus?, Never> { get }
    
    func startNotifyer()
    func stopNotifyer()
}
