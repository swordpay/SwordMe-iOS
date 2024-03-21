//
//  DecodingDataParserAssembly.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 12.04.22.
//

import Foundation
import Swinject

public final class DecodingDataParserAssembly: Assembly {
    public func assemble(container: Container) {
        container.register(DataParsing.self) { _ in
            return DecodingDataParser()
        }
    }
}
