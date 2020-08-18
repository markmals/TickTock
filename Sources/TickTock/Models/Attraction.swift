import Foundation
import Combine

extension ThemePark {
    public func attractions() -> AnyPublisher<[Attraction], Error> {
        struct AttractionResponse: Decodable {
            let name: String
            let type: String?
            let waitTime: WaitTime
        }
        
        struct WaitTime: Decodable {
            let fastPass: Bool
            let singleRider: Bool
            let status: String?
            let postedWaitMinutes: UInt?
            let rollUpWaitTimeMessage: String?
        }
        
        return authenticate()
            .mapError { $0 as Error }
            .flatMap { token in
                self.post(path: "global-pool-override-A/facility-service/theme-parks/\(self.id)/wait-times")
                    .response([AttractionResponse].self)
                    .headers([
                        "Authorization" : "BEARER \(token.accessToken)",
                        "X-Conversation-Id" : "WDPRO-MOBILE.MDX.CLIENT-PROD",
                        "X-App-Id" : "WDW-MDX-ANDROID-3.4.1",
                        "X-Correlation-ID" : "\(Date().timeIntervalSince1970)"
                    ])
                    .body("grant_type=assertion&assertion_type=public&client_id=WDPRO-MOBILE.MDX.WDW.ANDROID-PROD", encoder: JSONEncoder())
                    .publisher()
                    .map { $0.map { response in
                        var type: Attraction.AttractionType? = nil
                        var status: Attraction.Status? = nil
                        var minutes: UInt = response.waitTime.postedWaitMinutes ?? 0
                        
                        if let typeStr = response.type, let goodType = Attraction.AttractionType(rawValue: typeStr) {
                            type = goodType
                        }
                        
                        if let statusStr = response.waitTime.status, let goodStatus = Attraction.Status(rawValue: statusStr) {
                            status = goodStatus
                            
                            if goodStatus == .closed || goodStatus == .down {
                                minutes = 0
                            }
                        }
                        
                        return Attraction(
                            name: response.name,
                            type: type,
                            fastPassIsAvaliable: response.waitTime.fastPass,
                            singleRiderIsAvaliable: response.waitTime.singleRider,
                            status: status,
                            minutes: minutes,
                            message: response.waitTime.rollUpWaitTimeMessage
                        )
                    }}
            }
            .eraseToAnyPublisher()
    }
}

public struct Attraction: Equatable {
    /// The operating status of an attraction
    public enum Status: String {
        case operating = "Operating"
        case closed = "Closed"
        case down = "Down"
        case seasonal = "Operates Seasonally"
        case openingSoon = "Opening Soon"
    }
    
    /// The type of an attraction
    public enum AttractionType: String {
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
    public let minutes: UInt?
    /// The roll up wait time message
    public let message: String?
}

extension Attraction: Identifiable {
    /// Attraction's identifier for Identifiable, identical to `name`
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
        Wait time: \(minutes ?? 0) minutes
        Roll up wait time message: \(message ?? "Unavaliable")
        """
    }
}

extension Sequence where Iterator.Element == Attraction {
    public var isOperating: Bool {
        compactMap { $0.status }.contains(.operating)
    }
}
