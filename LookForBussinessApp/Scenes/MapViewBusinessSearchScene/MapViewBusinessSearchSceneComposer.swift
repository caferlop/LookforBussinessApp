//
//  MapViewBusinessSearchSceneComposer.swift
//  LookForBussinessApp
//
//  Created by carlos fernandez on 21/9/21.
//

import Foundation

public final class MapViewBusinessSearchSceneComposer {
    static func makeMapViewBusinessSearchViewController(mapView: Mapable, presenter: MapViewSearchable) -> MapViewBusinessSearchViewController {
        return MapViewBusinessSearchViewController(mapView: mapView, presenter: presenter)
    }
}
