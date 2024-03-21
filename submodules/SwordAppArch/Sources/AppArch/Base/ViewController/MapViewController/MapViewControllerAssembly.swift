//
//  MapViewControllerAssembly.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 11.05.22.
//

import Foundation
import Swinject
import CoreLocation

final class MapStackViewControllerAssembly: Assembly {
    let location: CLLocation
    let title: String?

    init(location: CLLocation, title: String?) {
        self.location = location
        self.title = title
    }

    func assemble(container: Container) {
        let location = location
        let title = title

        container.register(MapViewModel.self) { _ in
            return MapViewModel(location: location, title: title)
        }

        container.register(MapViewController.self) { resolver in
            let viewModel = resolver.resolve(MapViewModel.self)!
            let viewController = MapViewController()

            viewController.viewModel = viewModel

            return viewController
        }
    }
}
