//
//  CLLocationCoordinate2D+Extension.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/18/24.
//

import CoreLocation

extension CLLocationCoordinate2D {
    func distance(from: CLLocationCoordinate2D) -> CLLocationDistance {
        if ((from.latitude.isNaN && from.longitude.isNaN) ||
            (self.latitude.isNaN && self.longitude.isNaN)) {
            return -1
        }

        let destination = CLLocation(latitude: from.latitude, longitude: from.longitude)
        return CLLocation(latitude: latitude, longitude: longitude).distance(from: destination)
    }
}

extension CLLocationDistance {
    func formattedString() -> String {
        if self == -1 {
            return ""
        } else if self >= 1000 {
            let distanceInKm = self / 1000
            return String(format: "%.1fkm", distanceInKm)
        } else {
            return String(format: "%.0fm", self)
        }
    }
}
