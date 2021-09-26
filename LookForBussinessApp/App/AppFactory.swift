//
//  AppFactory.swift
//  LookForBussinessApp
//
//  Created by carlos fernandez on 26/9/21.
//

import Foundation
import LookForBussiness

protocol MapToBusinessScenes {
    func makeMapBussinessSearchController() -> MapViewBusinessSearchViewController
    func makeBusinessDetailsController() -> BusinessDetailsViewController
}

final class AppFactory: MapToBusinessScenes {
    
    private let getBusinesses: BusinessSearchable
    private let getBusinessDetails: BusinessDetailable
    
    init(getBusinesses: BusinessSearchable, getBusinessDetails: BusinessDetailable) {
        self.getBusinesses = getBusinesses
        self.getBusinessDetails = getBusinessDetails
    }
    
    func makeMapBussinessSearchController() -> MapViewBusinessSearchViewController {
        return MapViewBusinessSearchSceneComposer.makeMapViewBusinessSearchViewController(getBusinesses: getBusinesses)
    }
    
    func makeBusinessDetailsController() -> BusinessDetailsViewController {
        return BusinessDetailSceneComposer.makeBusinessDetailsViewController(getBusinessDetails: getBusinessDetails)
    }
    
}
