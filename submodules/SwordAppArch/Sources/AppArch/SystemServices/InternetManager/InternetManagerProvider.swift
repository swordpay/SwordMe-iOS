//
//  InternetManagerProvider.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 17.05.22.
//

import Foundation
import Swinject

enum InternetManagerProvider {
    static var reachability: InternetManaging = {
        let assembler = Assembler([InternetManagerAssembly()])

        return assembler.resolver.resolve(InternetManaging.self)!
    }()
}
