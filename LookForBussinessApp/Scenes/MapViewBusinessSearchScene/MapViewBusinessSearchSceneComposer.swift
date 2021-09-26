//
//  MapViewBusinessSearchSceneComposer.swift
//  LookForBussinessApp
//
//  Created by carlos fernandez on 21/9/21.
//

import Foundation
import LookForBussiness

public final class MapViewBusinessSearchSceneComposer {
    private static func makeLocationManager() -> Locationable {
        return LocationManager()
    }
    
    private static var mapViewDelegate: MapViewDelegatable = {
        MapViewDelegate()
    }()
    static func makeMapViewBusinessSearchPresenter(getBusinesses: BusinessSearchable) -> MapViewBusinessSearchPresenter {
        let locationManager = makeLocationManager()
        
        return MapViewBusinessSearchPresenter(getBusinesses: getBusinesses, locationManager: locationManager, mapViewDelegate: mapViewDelegate)
    }
    static func makeMapViewBusinessSearchViewController(getBusinesses: BusinessSearchable) -> MapViewBusinessSearchViewController {
        let presenter = makeMapViewBusinessSearchPresenter(getBusinesses: getBusinesses)
        let mapView = MapView()
        mapView.setDelegate(mapViewDelegate: mapViewDelegate)
        return MapViewBusinessSearchViewController(mapView: mapView, presenter: presenter)
    }
}
