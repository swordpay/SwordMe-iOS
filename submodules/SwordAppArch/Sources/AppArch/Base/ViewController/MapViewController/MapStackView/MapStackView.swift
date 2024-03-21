//
//  MapStackView.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 11.05.22.
//

import UIKit
import MapKit

final class MapStackView: SetupableStackView {
    typealias SetupModel = MapStackViewModel
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var mapView: MKMapView!
    
    // MARK: - Setup UI

    func setup(with model: MapStackViewModel) {
        mapView.centerToLocation(model.location)
        setPlacemark(location: model.location)
    }
    
    private func setPlacemark(location: CLLocation) {
        let placemark = MKPointAnnotation()

        placemark.coordinate = location.coordinate
        placemark.title = nil
        
        mapView.addAnnotation(placemark)
    }
}
