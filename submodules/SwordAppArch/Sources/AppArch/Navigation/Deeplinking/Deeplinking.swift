//
//  Deeplinking.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 29.06.22.
//

import UIKit


public protocol Deeplinking {
    func deeplink(to dest: DeeplinkDestinationing, completion: @escaping (UIViewController?) -> Void)
}

public struct DeeplinkManager {
    public static var segments: [DeeplinkDestinationing] = []

    public static var nextSegment: DeeplinkDestinationing? {
        guard !segments.isEmpty else { return nil }

        return segments.removeFirst()
    }

    public static func navigate(to controller: UIViewController? = nil) {
        guard let segment = nextSegment else { return }

        let vc = controller ?? UIApplication.shared.rootViewController()

        (vc as? Deeplinking)?.deeplink(to: segment) { vc in
            navigate(to: vc)
        }
    }
}
