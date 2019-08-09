//
//  Location.swift
//  TickTockCrock
//
//  Created by Mark Malstrom on 7/22/19.
//  Copyright © 2019 Mark Malstrom. All rights reserved.
//

import Foundation

public struct Location: Codable {
    public let latitude: Double
    public let longitude: Double
}

#if canImport(CoreLocation)
import CoreLocation

extension Location {
    public var coreLocation: CLLocation {
        return CLLocation(latitude: latitude, longitude: longitude)
    }
}
#endif
