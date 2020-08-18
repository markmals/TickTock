import Foundation
import CoreLocation
import Combine
import Resty

public final class ThemePark: API {
    public let baseURL: URL
    
    var cachedToken: Token? = nil
    var authSubscription: AnyCancellable? = nil
    
    public let id: UInt
    public let name: String
    public let shortName: String
    public let location: CLLocation
    public let timeZone: TimeZone
    
    init(baseURL: URL, id: UInt, name: String, shortName: String, location: CLLocation, timeZone: TimeZone) {
        self.baseURL = baseURL
        self.id = id
        self.name = name
        self.shortName = shortName
        self.location = location
        self.timeZone = timeZone
    }
    
    public static let disneyland = ThemePark(
        baseURL: URL(string: "https://api.wdpro.disney.go.com")!,
        id: 330339,
        name: "Disneyland",
        shortName: "Disneyland",
        location: CLLocation(latitude: 33.810109, longitude: -117.918971),
        timeZone: TimeZone(abbreviation: "PST")!
    )
}
