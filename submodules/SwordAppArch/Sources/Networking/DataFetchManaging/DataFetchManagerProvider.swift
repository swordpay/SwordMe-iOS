//
//  DataFetchManagerProvider.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 13.04.22.
//

import Foundation
import Swinject

public enum DataFetchManagerProvider {
    private static func dataFetchManager(from assemblies: [Assembly]) -> DataFetchManaging {
        let assembler = Assembler(assemblies)

        return assembler.resolver.resolve(DataFetchManaging.self)!
    }

    public static var mock: DataFetchManaging {
        return dataFetchManager(from: [JSONFetcherAssembly(),
                                       DataFetchMockValidatorAssembly(),
                                       DecodingDataParserAssembly(),
                                       DataFetchManagerAssembly()])
    }

    public static var web: DataFetchManaging {
        return dataFetchManager(from: [URLSessionFetcherAssembly(),
                                       DataFetchValidatorAssembly(),
                                       DecodingDataParserAssembly(),
                                       DataFetchManagerAssembly()])
    }
    
    static var webWithLongTimeout: DataFetchManaging {
        let config = URLSessionConfiguration.default

        config.timeoutIntervalForRequest = 300

        return dataFetchManager(from: [URLSessionFetcherAssembly(config: config),
                                       DataFetchValidatorAssembly(),
                                       DecodingDataParserAssembly(),
                                       DataFetchManagerAssembly()])
    }
}
