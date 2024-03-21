//
//  MapViewModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 11.05.22.
//

import Foundation
import CoreLocation
import Combine

final class MapViewModel: BaseViewModel<Void>, StackViewModeling {
    typealias SetupModel = MapStackViewModel

    var setupModel: CurrentValueSubject<MapStackViewModel?, Never> = CurrentValueSubject(nil)
    let title: String?

    init(location: CLLocation, title: String? = nil) {
        let model = MapStackViewModel(location: location)
        
        self.title = title
        self.setupModel.send(model)
        super.init(inputs: ())
    }
}
