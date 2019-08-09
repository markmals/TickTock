//
//  Attraction.swift
//  TickTockCrock
//
//  Created by Mark Malstrom on 7/22/19.
//  Copyright © 2019 Mark Malstrom. All rights reserved.
//

import Foundation

public struct Attraction: Decodable {
    static func request(for id: String, with token: Token) -> URLRequest {
        URLRequest(
            url: URL(string: "https://api.wdpro.disney.go.com/global-pool-override-A/facility-service/theme-parks/\(id)/wait-times"),
            method: .post,
            accept: .json,
            headerFields: [
                "Authorization" : "BEARER \(token.accessToken)",
                "X-Conversation-Id" : "WDPRO-MOBILE.MDX.CLIENT-PROD",
                "X-App-Id" : "WDW-MDX-ANDROID-3.4.1",
                "X-Correlation-ID" : "\(Date().timeIntervalSince1970)"
            ],
            body: "grant_type=assertion&assertion_type=public&client_id=WDPRO-MOBILE.MDX.WDW.ANDROID-PROD"
        )
    }
    
    /// The operating status of an attraction
    public enum Status: String, Decodable {
        case operating = "Operating"
        case closed = "Closed"
        case down = "Down"
        case seasonal = "Operates Seasonally"
        case openingSoon = "Opening Soon"
    }
    
    /// The type of an attraction
    public enum AttractionType: String, Decodable {
        case attraction = "Attraction"
        case entertainment = "Entertainment"
    }
    
    /// The name of the attraction
    public let name: String
    /// The type of the attraction
    public let type: AttractionType?
    /// True if the attraction has fast passes
    public let fastPassIsAvaliable: Bool
    /// True if the attraction has a single rider queue
    public let singleRiderIsAvaliable: Bool
    /// The operating status of the attraction
    public let status: Status?
    /// The posted wait time in minutes
    public let minutes: String?
    /// The roll up wait time message
    public let message: String?
}

extension Attraction {
    init(from attraction: Attraction, newName: String) {
        self.name = newName
        self.type = attraction.type
        self.fastPassIsAvaliable = attraction.fastPassIsAvaliable
        self.singleRiderIsAvaliable = attraction.singleRiderIsAvaliable
        self.status = attraction.status
        self.minutes = attraction.minutes
        self.message = attraction.message
    }
}

extension Attraction {
    private enum CodingKeys: String, CodingKey {
        case name
        case type
        case waitTime
    }
    
    private enum WaitTimeKeys: String, CodingKey {
        case fastPass
        case singleRider
        case rollUpWaitTimeMessage
        case postedWaitMinutes
        case status
    }
    
    private enum FastPassKey: String, CodingKey {
        case available
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let waitTime = try values.nestedContainer(keyedBy: WaitTimeKeys.self, forKey: .waitTime)
        let fastPass = try waitTime.nestedContainer(keyedBy: FastPassKey.self, forKey: .fastPass)
        
        self.name = try values.decode(String.self, forKey: .name)
        self.type = try? values.decode(AttractionType.self, forKey: .type)
        self.fastPassIsAvaliable = try fastPass.decode(Bool.self, forKey: .available)
        self.singleRiderIsAvaliable = try waitTime.decode(Bool.self, forKey: .singleRider)
        self.status = try? waitTime.decode(Status.self, forKey: .status)
        
        let minutesInt = try? waitTime.decode(Int.self, forKey: .postedWaitMinutes)
        
        if let tempStatus = try? waitTime.decode(Status.self, forKey: .status) {
            if tempStatus == .closed || tempStatus == .down {
                self.minutes = "0"
            } else {
                self.minutes = String(minutesInt ?? 0)
            }
        } else {
            self.minutes = String(minutesInt ?? 0)
        }
        
        self.message = try? waitTime.decode(String.self, forKey: .rollUpWaitTimeMessage)
    }
}

extension Attraction: Identifiable {
    /// The identifier for Identifiable, identical to `name`
    public var id: String {
        return name
    }
}

extension Attraction: CustomStringConvertible {
    public var description: String {
        return """
        Name: \(name)
        Type: \(type?.rawValue ?? "Unavaliable")
        FastPass is avaliable: \(fastPassIsAvaliable.polarity)
        Single Rider is avaliable: \(singleRiderIsAvaliable.polarity)
        Operating status: \(status?.rawValue ?? "Unavaliable")
        Wait time: \(minutes ?? "Unavaliable") minutes
        Roll up wait time message: \(message ?? "Unavaliable")
        """
    }
}

extension Sequence where Iterator.Element == Attraction {
    public var isStillOperating: Bool {
        var count = 0
        for attraction in self {
            if attraction.status == .operating { count += 1 }
        }
        return count != 0
    }
}
