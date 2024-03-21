//
//  CameraManaging.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 17.05.22.
//

import Foundation
import Combine

protocol CameraManaging {
    var authorizationStatusPublisher: CurrentValueSubject<CameraAuthorizationStatus?, Never> { get }

    func checkAuthorizationStatus()
    func authorizeCameraAccess()
}
