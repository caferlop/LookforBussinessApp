//
//  MapViewBusinessSearchSceneComposer.swift
//  LookForBussinessApp
//
//  Created by carlos fernandez on 21/9/21.
//

import Foundation
import LookForBussiness

public final class MapViewBusinessSearchSceneComposer {
    static func makeMapViewBusinessSearchPresenter(getBusinesses: BusinessSearchable) -> MapViewBusinessSearchPresenter {
        return MapViewBusinessSearchPresenter(getBusinesses: getBusinesses)
    }
    static func makeMapViewBusinessSearchViewController(getBusinesses: BusinessSearchable, coordinator: MainCoordinator) -> MapViewBusinessSearchViewController {
        let presenter = makeMapViewBusinessSearchPresenter(getBusinesses: getBusinesses)
        return MapViewBusinessSearchViewController(mapView: MapView(), presenter: presenter, coordinator: coordinator)
    }
}
