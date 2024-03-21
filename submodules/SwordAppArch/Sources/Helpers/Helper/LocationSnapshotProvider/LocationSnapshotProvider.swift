//
//  LocationSnapshotProvider.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 25.07.22.
//

import UIKit
import MapKit
import Combine
import CoreLocation

protocol LocationSnapshotProviding {
    func provideSnapshot(for location: CLLocation, with size: CGSize) -> Future<UIImage?, Never>
}

final class LocationSnapshotProvider: LocationSnapshotProviding {
    func provideSnapshot(for location: CLLocation, with size: CGSize) -> Future<UIImage?, Never> {
        
        return Future { [ weak self ] promise in
            
            guard let options = self?.prepareShnapshotOptions(for: location, with: size) else { return promise(.success(nil)) }

            let snapshotter = MKMapSnapshotter(options: options)

            snapshotter.start { [ weak self ] snapshot, _ in
                guard let self = self else {
                    promise(.success(nil))

                    return
                }

                if let snapshot = snapshot {
                    let annotatedImage = self.annotateLocationSnapshot(snapshot, for: location)
                    
                    return promise(.success(annotatedImage))
                }
            }
        }
    }
    
    // MARK: - Location Snapshot Preparation

    private func prepareShnapshotOptions(for location: CLLocation, with size: CGSize) -> MKMapSnapshotter.Options? {
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude

        let options: MKMapSnapshotter.Options = .init()
        let center = CLLocationCoordinate2D(latitude: latitude,
                                            longitude: longitude)
        let region = MKCoordinateRegion(center: center,
                                        latitudinalMeters: 1000,
                                        longitudinalMeters: 1000)

        options.region = region

        options.size = size
        options.mapType = .standard
        options.showsBuildings = true
        options.mapType = .standard
        options.traitCollection = UITraitCollection(userInterfaceStyle: .dark)

        return options
    }
    
    
    private func annotateLocationSnapshot(_ snapshot: MKMapSnapshotter.Snapshot, for location: CLLocation) -> UIImage {
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude

        let coordinates = CLLocationCoordinate2D(latitude: latitude,
                                                 longitude: longitude)
        let pointForCoordinates = snapshot.point(for: coordinates)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinates

        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "annotation")

        annotationView.frame.size = snapshot.image.size
        UIGraphicsBeginImageContextWithOptions(snapshot.image.size, true, snapshot.image.scale);

        snapshot.image.draw(at: .zero)

        let rect = CGRect(x: pointForCoordinates.x,
                          y: pointForCoordinates.y,
                          width: annotationView.frame.width,
                          height: annotationView.frame.height)
        annotationView.drawHierarchy(in: rect, afterScreenUpdates: true)


        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return finalImage ?? snapshot.image
    }

}
