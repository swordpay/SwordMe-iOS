//
//  CameraManager.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 20.04.22.
//

import UIKit
import AVKit
import Combine

enum CameraAuthorizationStatus {
    case authorized
    case unauthorized
    case notDetermined
}

final class CameraManager: NSObject, CameraManaging {
    
    private var cancellables: Set<AnyCancellable> = []

    let authorizationStatusPublisher: CurrentValueSubject<CameraAuthorizationStatus?, Never> = CurrentValueSubject(nil)

    override init() {
        super.init()
        
        NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification, object: nil)
            .sink { _ in
                let authorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
                let status: CameraAuthorizationStatus
                switch authorizationStatus {
                case .notDetermined, .denied, .restricted:
                    status = .unauthorized
                default:
                    status = .authorized
                }
                

                DispatchQueue.main.async { [ weak self ] in
                    self?.authorizationStatusPublisher.send(status)
                }
            }
            .store(in: &cancellables)
    }

    func checkAuthorizationStatus() {
        let systemStatus = AVCaptureDevice.authorizationStatus(for: .video)
        let status: CameraAuthorizationStatus
        switch systemStatus {
        case .notDetermined:
            status = .notDetermined
        case .denied:
            status = .unauthorized
        default:
            status = .authorized
        }
        
        authorizationStatusPublisher.send(status)
    }
    
    func authorizeCameraAccess() {
        if AVCaptureDevice.authorizationStatus(for: .video) == .notDetermined {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { [ weak self ] (granted: Bool) in
                let status: CameraAuthorizationStatus = granted ? .authorized : .unauthorized
                
                self?.authorizationStatusPublisher.send(status)
            })
        }
    }
}
