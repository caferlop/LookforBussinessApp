//
//  LocationManager.swift
//  LookForBussinessApp
//
//  Created by carlos fernandez on 26/9/21.
//

import Foundation
import MapKit

public protocol Locationable {
    var currentLocation: (_ Coordinates: Coordinates) -> Void { get set }
    func requestAuthorization()
}

public final class LocationManager: NSObject {
    
    private var personalLocation: (Coordinates) -> Void = { _ in }
    
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
}

extension LocationManager: Locationable {
    public var currentLocation: (Coordinates) -> Void {
        get {
            return self.personalLocation
        }
        
        set {
            self.personalLocation = newValue
        }
    }
    
    public func requestAuthorization() {
        locationManager.requestLocation()
        locationManager.requestAlwaysAuthorization()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            let coordinate = Coordinates(latitude: latitude, longitude: longitude)
            self.personalLocation(coordinate)
            locationManager.stopUpdatingLocation()
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Handle failure to get a user’s location
    }
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    locationManager.startUpdatingLocation()
                }
            }
        }
    }
}
