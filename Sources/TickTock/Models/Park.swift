//
//  Park.swift
//  TickTockCrock
//
//  Created by Mark Malstrom on 7/22/19.
//  Copyright © 2019 Mark Malstrom. All rights reserved.
//

import Foundation

public struct Park {
    public let id: String
    public let name: String
    public let shortName: String
    public let location: Location
    public let timeZone: TimeZone
}

extension Park {
    public static let disneyland = Park(
        id: "330339",
        name: "Disneyland",
        shortName: "Disneyland",
        location: Location(latitude: 33.810109, longitude: -117.918971),
        timeZone: TimeZone(abbreviation: "PST")!
    )
    
    public static let californiaAdventure = Park(
        id: "336894",
        name: "California Adventure",
        shortName: "DCA",
        location: Location(latitude: 33.808720, longitude: -117.918990),
        timeZone: TimeZone(abbreviation: "PST")!
    )
    
    public static let magicKingdom = Park(
        id: "80007944",
        name: "Magic Kingdom",
        shortName: "MK",
        location: Location(latitude: 28.3852, longitude: -81.5639),
        timeZone: TimeZone(abbreviation: "EST")!
    )
    
    public static let epcot = Park(
        id: "80007838",
        name: "Epcot",
        shortName: "Epcot",
        location: Location(latitude: 28.3747, longitude: -81.5494),
        timeZone: TimeZone(abbreviation: "EST")!
    )
    
    public static let hollywoodStudios = Park(
        id: "80007998",
        name: "Hollywood Studios",
        shortName: "DHS",
        location: Location(latitude: 28.3575, longitude: -81.5582),
        timeZone: TimeZone(abbreviation: "EST")!
    )
    
    public static let animalKingdom = Park(
        id: "80007823",
        name: "Animal Kingdom",
        shortName: "DAK",
        location: Location(latitude: 28.3553, longitude: -81.5901),
        timeZone: TimeZone(abbreviation: "EST")!
    )
}
