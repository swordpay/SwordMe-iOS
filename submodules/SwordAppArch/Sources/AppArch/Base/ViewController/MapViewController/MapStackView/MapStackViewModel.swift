//
//  MapStackViewModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 11.05.22.
//

import Foundation
import CoreLocation

final class MapStackViewModel {
    let location: CLLocation

    init(location: CLLocation) {
        self.location = location
    }
}
