//
//  Park.swift
//  TickTockCrock
//
//  Created by Mark Malstrom on 7/22/19.
//  Copyright © 2019 Mark Malstrom. All rights reserved.
//

import Foundation
#if canImport(Combine)
import Combine
#else
import OpenCombine
#endif
import TinyNetworking

public class Park {
    public let instance: Instance
    private var token = Authentication.Token()
    
    init(for instance: Instance) {
        self.instance = instance
        
        self.schedulesURL = URL(string: "https://api.wdpro.disney.go.com/global-pool-override-A/facility-service/schedules/\(instance.id)")!
        self.attractionsURL = URL(string: "https://api.wdpro.disney.go.com/global-pool-override-A/facility-service/theme-parks/\(instance.id)/wait-times")!
    }
    
    private func makeEndpoint<A: Decodable>(for url: URL) -> Endpoint<A> {
        Endpoint<A>(
            json: .get,
            url: url,
            headers: [
                "Authorization" : "BEARER \(token.accessToken)",
                "Accept" : "application/json;apiversion=1",
                "X-Conversation-Id" : "WDPRO-MOBILE.MDX.CLIENT-PROD",
                "X-App-Id" : "WDW-MDX-ANDROID-3.4.1",
                "X-Correlation-ID" : "\(Date().timeIntervalSince1970)"
            ]
        )
    }
    
    // MARK: Schedule Data
    private let schedulesURL: URL
    lazy private var schedulesEndpoint: Endpoint<Schedule> = makeEndpoint(for: schedulesURL)
    lazy public private(set) var schedulesPublisher = Authentication.publisher
        .flatMap { (token) -> AnyPublisher<Schedule, Error> in
            self.token = token
            return URLSession.shared.endpointPublisher(self.schedulesEndpoint)
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    
    // MARK: Attractions Data
    private let attractionsURL: URL
    lazy private var attractionsEndpoint: Endpoint<[Attraction]> = makeEndpoint(for: attractionsURL)
    lazy public private(set) var attractionsPublisher = Authentication.publisher
        .flatMap { (token) -> AnyPublisher<[Attraction], Error> in
            self.token = token
            return URLSession.shared.endpointPublisher(self.attractionsEndpoint)
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
}

extension Park {
    public struct Instance {
        public let id: String
        public let name: String
        public let shortName: String
        public let location: Location
        public let timeZone: TimeZone
    }
}

extension Park.Instance {
    public static let disneyland = Park.Instance(
        id: "330339",
        name: "Disneyland",
        shortName: "Disneyland",
        location: Location(latitude: 33.810109, longitude: -117.918971),
        timeZone: TimeZone(abbreviation: "PST")!
    )
    
    public static let californiaAdventure = Park.Instance(
        id: "336894",
        name: "California Adventure",
        shortName: "DCA",
        location: Location(latitude: 33.808720, longitude: -117.918990),
        timeZone: TimeZone(abbreviation: "PST")!
    )
    
    public static let magicKingdom = Park.Instance(
        id: "80007944",
        name: "Magic Kingdom",
        shortName: "MK",
        location: Location(latitude: 28.3852, longitude: -81.5639),
        timeZone: TimeZone(abbreviation: "EST")!
    )
    
    public static let epcot = Park.Instance(
        id: "80007838",
        name: "Epcot",
        shortName: "Epcot",
        location: Location(latitude: 28.3747, longitude: -81.5494),
        timeZone: TimeZone(abbreviation: "EST")!
    )
    
    public static let hollywoodStudios = Park.Instance(
        id: "80007998",
        name: "Hollywood Studios",
        shortName: "DHS",
        location: Location(latitude: 28.3575, longitude: -81.5582),
        timeZone: TimeZone(abbreviation: "EST")!
    )
    
    public static let animalKingdom = Park.Instance(
        id: "80007823",
        name: "Animal Kingdom",
        shortName: "DAK",
        location: Location(latitude: 28.3553, longitude: -81.5901),
        timeZone: TimeZone(abbreviation: "EST")!
    )
}
