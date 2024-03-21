//
//  MKMapView+Addition.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 04.07.22.
//

import MapKit
import Foundation

extension MKMapView {
  func centerToLocation(_ location: CLLocation, regionRadius: CLLocationDistance = 1000) {
      let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                latitudinalMeters: regionRadius,
                                                longitudinalMeters: regionRadius)

      setRegion(coordinateRegion, animated: true)
  }
}
