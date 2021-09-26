//
//  MapViewDelegate.swift
//  LookForBussinessApp
//
//  Created by carlos fernandez on 26/9/21.
//

import Foundation
import MapKit

public protocol MapViewRegionDelegatable {
    var regionCoordinates: (Coordinates) -> Void { get set }
}

public protocol MapViewAnnotationDelegatable {
    var selectedAnnotation: (String) -> Void { get set }
}

typealias MapViewDelegatable = MKMapViewDelegate & MapViewRegionDelegatable & MapViewAnnotationDelegatable

final class MapViewDelegate: NSObject {
    private var delegateSelectedAnnotation: (String) -> Void = {_ in }
    private var delegateRegionCoordinates: (Coordinates) -> Void = {_ in }
    override init(){
        super.init()
    }
}

extension MapViewDelegate: MapViewRegionDelegatable {
    var regionCoordinates: (Coordinates) -> Void {
        get {
            return delegateRegionCoordinates
        }
        set {
            delegateRegionCoordinates = newValue
        }
    }
}

extension MapViewDelegate: MapViewAnnotationDelegatable {
    var selectedAnnotation: (String) -> Void {
        get {
            return delegateSelectedAnnotation
        }
        set {
            delegateSelectedAnnotation = newValue
        }
    }
}

extension MapViewDelegate: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let businessAnnotations = view.annotation as? BusinessAnnotations {
            self.delegateSelectedAnnotation(businessAnnotations.id)
        }
    }
    
    func mapView(_ myMap: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = myMap.centerCoordinate
        let coordinates = Coordinates(latitude: center.latitude, longitude: center.longitude)
        self.delegateRegionCoordinates(coordinates)
    }
}
