//
//  APILocation.swift
//  iSpyChallenge
//
//

import Foundation
import CoreLocation

struct APILocation: Codable, Hashable {
    var latitude: Double
    var longitude: Double
}

extension APILocation {
    func getLocation() -> CLLocation {
        CLLocation(latitude: latitude, longitude: longitude)
    }
}
