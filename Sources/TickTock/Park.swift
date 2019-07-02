//
//  Park.swift
//  
//
//  Created by Mark Malstrom on 7/1/19.
//

import Foundation
import TinyNetworking
// import Burritos

public class Park {
    private var token = Authentication()
    
    // Fetch a brand new access token on the creation of a Park instance
    init() {
        token.accessToken { (result) in
            self.token = (try? result.get())?.1 ?? Authentication()
        }
    }

    static func authentication() -> Endpoint<Authentication> {
        Endpoint(
            json: .post,
            url: URL(string: "https://authorization.go.com/token")!,
            accept: .json,
            body: "grant_type=assertion&assertion_type=public&client_id=WDPRO-MOBILE.MDX.WDW.ANDROID-PROD"
                .data(using: .utf8)
        )
    }
    
    private func endpoint<T: Decodable>(url: URL, accessToken: String) -> Endpoint<T> {
        Endpoint<T>(
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
    
    private func fetch<T: Decodable>(for url: URL, onComplete: @escaping (Result<Endpoint<T>, Error>) -> ()) {
        token.accessToken { (result) in
            switch result {
            case .success(let tuple):
                let access = tuple.0
                
                onComplete(
                    .success(
                        self.endpoint(
                            url: url,
                            accessToken: access
                        )
                    )
                )
        
                if let newToken = tuple.1 {
                    self.token = newToken
                }
            case .failure(let error):
                onComplete(.failure(error))
            }
        }
    }
    
    func schedule(for id: String, onComplete: @escaping (Result<Endpoint<Schedule>, Error>) -> ()) {
        let url = URL(string: "https://api.wdpro.disney.go.com/global-pool-override-A/facility-service/schedules/\(id)")!
        
        fetch(for: url) { (result) in
            onComplete(result)
        }
    }

    func waitTimes(for id: String, onComplete: @escaping (Result<Endpoint<[Attraction]>, Error>) -> ()) {
        let url = URL(string: "https://api.wdpro.disney.go.com/global-pool-override-A/facility-service/theme-parks/\(id)/wait-times")!
        
        fetch(for: url) { (result) in
            onComplete(result)
        }
    }
}
