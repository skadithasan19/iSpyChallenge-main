//
//  Challenge.swift
//  iSpyChallenge
//
//

import Foundation
import CoreLocation

struct Challenge: Codable, Hashable {
    var id: String
    var hint: String
    var latitude: Double
    var longitude: Double
    var photoImageName: String
    var creatorID: String
    var matches: [Match] = []
    var ratings: [Rating] = []
}

extension Challenge {
    func getLocation() -> CLLocation {
        CLLocation(latitude: latitude, longitude: longitude)
    }
}
