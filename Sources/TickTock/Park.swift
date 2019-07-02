//
//  Park.swift
//  TickTock
//
//  Created by Mark Malstrom on 7/2/19.
//  Copyright © 2019 Mark Malstrom. All rights reserved.
//

import Foundation
import TinyNetworking
#if canImport(Combine)
import Combine
#elseif
import OpenCombine
#endif

class Park {
    static let authentication = Authentication()
    
    static func endpoint<T: Decodable>(url: URL, accessToken: String) -> Endpoint<T>? {
        guard !accessToken.isEmpty else { return nil }
        
        return Endpoint<T>(
            json: .get,
            url: url,
            headers: [
                "Authorization" : "BEARER \(accessToken)",
                "Accept" : "application/json;apiversion=1",
                "X-Conversation-Id" : "WDPRO-MOBILE.MDX.CLIENT-PROD",
                "X-App-Id" : "WDW-MDX-ANDROID-3.4.1",
                "X-Correlation-ID" : "\(Date().timeIntervalSince1970)"
            ]
        )
    }
    
    public let park: Bespoke
    public let schedule: Schedule
    
    public init(park: Bespoke) {
        self.park = park
        self.schedule = Schedule(for: park.id)
    }
    
    func applyFilter() {}
}

extension Park {
    struct Bespoke {
        public let id: String
        public let name: String
        public let shortName: String
        public let location: Location
        public let timeZone: TimeZone
    }
}

extension Park.Bespoke {
    static let disneyland = Park.Bespoke(
        id: "330339",
        name: "Disneyland",
        shortName: "Disneyland",
        location: Location(latitude: 33.810109, longitude: -117.918971),
        timeZone: TimeZone(abbreviation: "PST")!
    )
    
    static let californiaAdventure = Park.Bespoke(
        id: "336894",
        name: "California Adventure",
        shortName: "DCA",
        location: Location(latitude: 33.808720, longitude: -117.918990),
        timeZone: TimeZone(abbreviation: "PST")!
    )
}
