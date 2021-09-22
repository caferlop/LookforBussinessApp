//
//  MapView.swift
//  LookForBussinessApp
//
//  Created by carlos fernandez on 21/9/21.
//

import UIKit
import MapKit
import CoreLocation

protocol Mapable: AnyObject {
    var view: UIView { get }
    var selectedLocation: (String) -> Void { get set }
    var currentLocation: (_ Coordinates: Coordinates) -> Void { get set }
    func passLocations(locations:[BusinessLocation])
    func setUpMapView()
}

struct Coordinates {
    let latitude: Double
    let longitude: Double
}

struct BusinessLocation {
    let id: String
    let name: String
    let coordinates: Coordinates
}

fileprivate final class BusinessAnnotations: NSObject, MKAnnotation {
    var title: String?
    var id: String
    var coordinate: CLLocationCoordinate2D

    init(title: String, coordinate: CLLocationCoordinate2D, id: String) {
        self.title = title
        self.coordinate = coordinate
        self.id = id
    }
}

class MapView: UIView {
    
    private let mkMapView = MKMapView()
    private var selectedAnnotation: (String) -> Void = { _ in }
    private var personalLocation: (Coordinates) -> Void = { _ in }
    private let locationManager = CLLocationManager()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        mkMapView.delegate = self
        locationManager.delegate = self
        locationManager.requestLocation()
        locationManager.requestAlwaysAuthorization()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension MapView: Mapable {
    
    var selectedLocation: (String) -> Void {
        get {
            return self.selectedAnnotation
        }
        set {
            self.selectedAnnotation = newValue
        }
    }
    
    var currentLocation: (Coordinates) -> Void {
        get {
            return self.personalLocation
        }
        set {
            self.personalLocation = newValue
        }
    }
    
    var view: UIView {
        return self
    }
    
    func passLocations(locations: [BusinessLocation]) {
        DispatchQueue.main.async {
            let annotations = locations.toMKAnnotations()
            self.mkMapView.addAnnotations(annotations)
        }
    }
    
    func setUpMapView() {
        self.addSubview(mkMapView)
        mkMapView.pinEdges(to: self)
        mkMapView.mapType = MKMapType.standard
        mkMapView.isZoomEnabled = true
        mkMapView.isScrollEnabled = true
    }
    
    private func setCenterInMap(location: Coordinates) {
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: location.toCLLocationCoordinate2D(), span: span)
        mkMapView.setRegion(region, animated: true)
    }
}

extension MapView: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let businessAnnotations = view.annotation as? BusinessAnnotations
        self.selectedAnnotation(businessAnnotations?.id ?? "")
    }
    
    func mapView(_ myMap: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = myMap.centerCoordinate
        let coordinates = Coordinates(latitude: center.latitude, longitude: center.longitude)
        self.personalLocation(coordinates)
    }
}

extension MapView: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            let coordinate = Coordinates(latitude: latitude, longitude: longitude)
            self.personalLocation(coordinate)
            self.setCenterInMap(location: coordinate)
            locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Handle failure to get a user’s location
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    locationManager.startUpdatingLocation()
                }
            }
        }
    }
    
}

private extension Coordinates {
    func toCLLocationCoordinate2D() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }
}

private extension Array where Element == BusinessLocation {
    func toMKAnnotations() -> [BusinessAnnotations] {
        return map { BusinessAnnotations(title: $0.name, coordinate: CLLocationCoordinate2D(latitude: $0.coordinates.latitude, longitude: $0.coordinates.longitude), id: $0.id)}
    }
}



