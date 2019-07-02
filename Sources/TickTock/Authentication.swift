//
//  Authentication.swift
//  
//
//  Created by Mark Malstrom on 7/1/19.
//

import Foundation

extension Park {
    struct Authentication: Decodable {
        /// The access_token for authentication of the Disney API
        private let access_token: String = ""
        
        // expiresIn is the maximum time the access_token is valid.
        // It's possible for the token to be given back just moments before
        // it is invalid. Therefore we should force the ttl value in the
        // cache lower than this value so requests don't fail.
        
        private let expires_in: String? = nil
        
        /// Seconds until expiration of the accessToken
        var expiresIn: Int? {
            return Int(expires_in ?? "0")
        }
        /// When the authentication was retrieved
        let timeCreated = Date()
        
        func accessToken(onComplete: @escaping (Result<(String, Authentication?), Error>) -> ()) {
            if !shouldRefresh {
                onComplete(.success((access_token, nil)))
            }
            
            URLSession.shared.load(Park.authentication()) { result in
                switch result {
                case .success(let authToken):
                    onComplete(.success((authToken.access_token, authToken)))
                case .failure(let error):
                    onComplete(.failure(error))
                }
            }
        }
        
        /// When a new authentication should be created so the current one doesn't expire during use
        var refreshTime: Date {
            guard let expiresIn = expiresIn else {
                return Date()
            }
            
            let calendar = Calendar.current
            return calendar.date(byAdding: .second, value: Int(ceil(Double(expiresIn) * 0.9)), to: timeCreated)!
        }
        
        var shouldRefresh: Bool { refreshTime <= Date() }
    }
}
