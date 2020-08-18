import Foundation
import Combine

extension ThemePark {
    private func authenticate(with token: Token?) -> AnyPublisher<Token, Never> {
        if let token = token, token.isValid {
            return Just(token).eraseToAnyPublisher()
        }
        
        return request(.post, url: URL(string: "https://authorization.go.com/token")!)
            .accept(.json)
            .body("grant_type=assertion&assertion_type=public&client_id=WDPRO-MOBILE.MDX.WDW.ANDROID-PROD", encoder: JSONEncoder())
            .publisher()
            .decode(type: Token.self, decoder: JSONDecoder())
            .map { $0 as Token? }
            .catch { _ in Just(nil) }
            // FIXME: Is recursively calling this method in a flatMap like this actually the best caching strategy?
            .flatMap { retrievedToken -> AnyPublisher<Token, Never> in
                self.cachedToken = retrievedToken
                return self.authenticate(with: self.cachedToken)
            }
            .eraseToAnyPublisher()
    }
    
    func authenticate() -> AnyPublisher<Token, Never> {
        authenticate(with: cachedToken)
    }
}

struct Token: Decodable {
    /// The access_token for authentication of the Disney API
    let accessToken: String
    
    /// expiresIn is the maximum time the access_token is valid.
    /// It's possible for the token to be given back just moments before it is invalid.
    private let expiresIn: String?
    
    /// Seconds until expiration of the accessToken
    var secondsUntilExpiration: Int {
        Int(ceil(Double(expiresIn ?? "0")! * 0.9))
    }
    
    /// When the authentication was retrieved
    let timeCreated = Date()
    
    /// When a new authentication should be created so the current one doesn't expire during use
    var refreshTime: Date {
        Calendar.current.date(byAdding: .second, value: secondsUntilExpiration, to: timeCreated)!
    }
    
    /// If this token is still a valid token or if it needs to be refreshed
    var isValid: Bool {
        refreshTime <= Date()
    }
    
    private enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case expiresIn = "expires_in"
    }
}
