//
//  MapViewBusinessSearchPresenter.swift
//  LookForBussinessApp
//
//  Created by carlos fernandez on 21/9/21.
//

import Foundation

protocol MapViewBusinessSearchableInput: AnyObject {
    func loadBussinessBy(term: String, coordinates: Coordinates)
    func loadBussinessBy(term: String)
}

protocol MapViewBusinessSearchableOutput: AnyObject {
    
}

typealias MapViewSearchable = MapViewBusinessSearchableInput & MapViewBusinessSearchableOutput

public final class MapViewBusinessSearchPresenter: MapViewSearchable {
    func loadBussinessBy(term: String, coordinates: Coordinates) {
        
    }
    
    func loadBussinessBy(term: String) {
        
    }
}
