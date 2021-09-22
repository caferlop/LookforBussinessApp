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
    func loadBussinessesByLocation(coordinates: Coordinates, completion: @escaping (MapViewDataModel) -> Void)
}

protocol MapViewBusinessSearchableOutput: AnyObject {
    
}

typealias MapViewSearchable = MapViewBusinessSearchableInput & MapViewBusinessSearchableOutput

public final class MapViewBusinessSearchPresenter: MapViewSearchable {

    private let getBusinesses: BusinessSearchable
    
    public init(getBusinesses: BusinessSearchable) {
        self.getBusinesses = getBusinesses
    }
    
    func loadBussinessesByLocation(coordinates: Coordinates, completion: @escaping (MapViewDataModel) -> Void) {
        let request = GetBusinessesEndPoint.getBussinessByLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
        self.getBusinesses.getBusinessess(request: request) { result in
            switch result {
            case .success(let business):
                let businessLocations = business.toBussinessLocation()
                completion(.success(MapViewBusinessSearchDataModel(businessLocations: businessLocations)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

private extension Array where Element == Business {
    func toBussinessLocation() -> [BusinessLocation] {
        return map { BusinessLocation(id: $0.id, name: $0.name, coordinates: Coordinates(latitude: $0.coordinates.latitude, longitude: $0.coordinates.longitude)) }
    }
}
