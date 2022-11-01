//
//  LocationManager.swift
//  iSpyChallenge
//
//  Created by Adit Hasan on 10/28/22.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    private let locationManager = CLLocationManager()
    static let shared = LocationManager()
    @Published var userLocation: CLLocation = CLLocation(latitude: 37.7904462,
                                                         longitude: -122.4011537)
    
    override init() {
        super.init()
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        } else {
            userLocation = CLLocation(latitude: 0, longitude: 0)
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue = manager.location else { return }
        print("locations = \(locValue.coordinate.latitude) \(locValue.coordinate.longitude)")
        userLocation = locValue
        manager.stopUpdatingLocation()
    }
    
    func getDistanceFrom(location: CLLocation) -> Double {
        return userLocation.distance(from: location) / 1609.4
    }
}
