//
//  URL+Addition.swift
//  SwordAppArch
//
//  Created by Tigran Simonyan on 07.09.23.
//

import Foundation
import UniformTypeIdentifiers

extension URL {
    var fileType: UTType? {
        let fileExtension = self.pathExtension
        
        return UTType(fileExtension)
    }
}
