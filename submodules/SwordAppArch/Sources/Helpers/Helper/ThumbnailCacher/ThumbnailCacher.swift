//
//  ThumbnailCacher.swift
//  SwordAppArch
//
//  Created by Tigran Simonyan on 01.02.24.
//

import UIKit
import CoreImage
public final class ThumbnailCacher {
    public static let global: ThumbnailCacher = {
        struct SingletonWrapper {
            static let singleton = ThumbnailCacher()
        }
        
        return SingletonWrapper.singleton
    }()
    
    var cache: [Int: Data] = [:]
    private init() {
        
    }
    
    func getData(by id: Int) -> Data? {
        return cache[id]
    }
    
    func addData(_ data: Data, for id: Int) {
        cache[id] = data
    }
}
