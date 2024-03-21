//
//  CameraManagerProvider.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 17.05.22.
//

import Swinject
import Foundation

enum CameraManagerProvider {
    static var native: CameraManaging = {
        let assembler = Assembler([CameraManagerAssembly()])

        return assembler.resolver.resolve(CameraManaging.self)!
    }()
}
