//
//  MapView.swift
//  LookForBussinessApp
//
//  Created by carlos fernandez on 21/9/21.
//

import UIKit
import MapKit

protocol Mapable: AnyObject {
    var view: UIView { get }
    var selectedLocation: (String) -> Void { get set }
    func passLocations(locations:[BusinessLocation])
}

struct Coordinates {
    let latitude: Double
    let longitude: Double
}

struct BusinessLocation {
    let id: String
    let info: String
    let coordinates: Coordinates
}

fileprivate final class BusinessAnnotations: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String

    init(title: String, coordinate: CLLocationCoordinate2D, info: String) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
    }
}

class MapView: UIView {
    
    private let mapView = MKMapView()
    private var selectedAnnotation: (String) -> Void = { _ in }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpMapView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setUpMapView() {
        mapView.pinEdges(to: self)
        mapView.mapType = MKMapType.standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
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
    
    var view: UIView {
        return self
    }
    
    func passLocations(locations: [BusinessLocation]) {
        mapView.addAnnotations(locations.toMKAnnotations())
    }
}

extension MapView: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        self.selectedAnnotation((view.annotation?.title ?? "")!)
    }
}

private extension Array where Element == BusinessLocation {
    func toMKAnnotations() -> [BusinessAnnotations] {
        return map { BusinessAnnotations(title: $0.id, coordinate: CLLocationCoordinate2D(latitude: $0.coordinates.latitude, longitude: $0.coordinates.longitude), info: $0.info)}
    }
}

