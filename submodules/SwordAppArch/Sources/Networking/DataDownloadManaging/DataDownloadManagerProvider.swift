//
//  DataDownloadManagerProvider.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 17.06.22.
//

import Swinject
import Foundation

public enum DataDownloadManagerProvider {
    static var `default`: DataDownloadManaging = {
        let assemblies: [Assembly] = [URLSessionDataDownloaderAssembly(),
                                      DataCacherAssembly(),
                                      DataDownloadManagerAssembly()]
        let assembler = Assembler(assemblies)

        return assembler.resolver.resolve(DataDownloadManaging.self)!
    }()
}
