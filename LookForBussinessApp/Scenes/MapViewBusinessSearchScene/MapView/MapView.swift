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
    var mapViewDelegate: MapViewDelegatable? { get set }
    func passLocations(locations:[BusinessLocation])
    func setUpMapView()
}

public struct Coordinates {
    public let latitude: Double
    public let longitude: Double
}

public struct BusinessLocation {
    public let id: String
    public let name: String
    public let coordinates: Coordinates
}

public final class BusinessAnnotations: NSObject, MKAnnotation {
    public var title: String?
    public var id: String
    public var coordinate: CLLocationCoordinate2D

    init(title: String, coordinate: CLLocationCoordinate2D, id: String) {
        self.title = title
        self.coordinate = coordinate
        self.id = id
    }
}

class MapView: UIView {
    
    private let mkMapView = MKMapView()
    private var selectedAnnotation: (String) -> Void = { _ in }
    var mapDelegate: MapViewDelegatable?
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setDelegate(mapViewDelegate: MapViewDelegatable) {
        mkMapView.delegate = mapViewDelegate
        self.mapDelegate = mapViewDelegate
    }
}

extension MapView: Mapable {
    
    var mapViewDelegate: MapViewDelegatable? {
        get {
            return self.mapDelegate
        }
        set {
            self.mapDelegate = newValue
        }
    }
    
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
        DispatchQueue.main.async {
            let annotations = locations.toMKAnnotations()
            self.mkMapView.addAnnotations(annotations)
            self.setCenterInMap(location: locations.first?.coordinates)
        }
    }
    
    func setUpMapView() {
        self.addSubview(mkMapView)
        mkMapView.pinEdges(to: self)
        mkMapView.mapType = MKMapType.standard
        mkMapView.isZoomEnabled = true
        mkMapView.isScrollEnabled = true
    }
    
    private func setCenterInMap(location: Coordinates?) {
        if let location = location {
            let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            let region = MKCoordinateRegion(center: location.toCLLocationCoordinate2D(), span: span)
            mkMapView.setRegion(region, animated: true)
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



