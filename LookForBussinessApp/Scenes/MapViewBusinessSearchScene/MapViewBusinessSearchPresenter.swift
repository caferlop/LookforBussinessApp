//
//  MapViewBusinessSearchPresenter.swift
//  LookForBussinessApp
//
//  Created by carlos fernandez on 21/9/21.
//

import Foundation
import LookForBussiness

protocol MapViewBusinessSearchableInput: AnyObject {
    typealias MapViewDataModel = Swift.Result<MapViewBusinessSearchDataModel, Error>
    var loadBusinessesListener: (MapViewDataModel) -> Void { get set }
    func requestLocation()
}

protocol MapViewBusinessSearchableOutput: AnyObject {}

typealias MapViewSearchable = MapViewBusinessSearchableInput & MapViewBusinessSearchableOutput

public final class MapViewBusinessSearchPresenter: MapViewSearchable {

    private let getBusinesses: BusinessSearchable
    private var locationManager: Locationable
    private var mapViewDelegate: (MapViewRegionDelegatable & MapViewAnnotationDelegatable)
    private var loadBusinessesByLocation: (MapViewDataModel) -> Void = {_ in}
    private var isUserLocation = true
    
    public init(getBusinesses: BusinessSearchable, locationManager: Locationable, mapViewDelegate: (MapViewRegionDelegatable & MapViewAnnotationDelegatable)) {
        self.getBusinesses = getBusinesses
        self.locationManager = locationManager
        self.mapViewDelegate = mapViewDelegate
    }
    
    var loadBusinessesListener: (MapViewDataModel) -> Void {
        get {
            return loadBusinessesByLocation
        }
        set {
            loadBusinessesByLocation = newValue
        }
    }
    
    func requestLocation() {
        self.locationManager.requestAuthorization()
        loadBusinessByRegionLocation()
    }
    
    private func loadBusinessByRegionLocation() {
        if isUserLocation {
            self.businessWithUserLocation()
            isUserLocation = false
        } else {
            self.businessWithRegionLocation()
        }
    }
    
    private func businessWithUserLocation() {
        self.locationManager.currentLocation = {  [weak self] currentCoordinates in
            guard let self = self else { return }
            print("currentCoordinates", currentCoordinates)
            self.getBusinessesWith(coordinates: currentCoordinates)
            self.loadBusinessByRegionLocation()
        }
    }
    
    private func businessWithRegionLocation() {
        self.mapViewDelegate.regionCoordinates = {  [weak self] regionCoordinates in
            guard let self = self else { return }
            print("regionCoordinates", regionCoordinates)
            self.getBusinessesWith(coordinates: regionCoordinates)
            self.loadBusinessByRegionLocation()
        }
    }
    
    private func getBusinessesWith(coordinates: Coordinates?) {
        if let currentLocation = coordinates {
            let request = GetBusinessesEndPoint.getBussinessByLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
        
            self.getBusinesses.getBusinessess(request: request) { result in
                switch result {
                case .success(let business):
                    let businessLocations = business.toBussinessLocation()
                    self.loadBusinessesByLocation(.success(MapViewBusinessSearchDataModel(businessLocations: businessLocations)))
                case .failure(let error):
                    self.loadBusinessesByLocation(.failure(error))
                }
            }
        }
    }
}

private extension Array where Element == Business {
    func toBussinessLocation() -> [BusinessLocation] {
        return map { BusinessLocation(id: $0.id, name: $0.name, coordinates: Coordinates(latitude: $0.coordinates.latitude, longitude: $0.coordinates.longitude)) }
    }
}
