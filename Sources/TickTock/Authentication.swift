//
//  Authentication.swift
//  TickTock
//
//  Created by Mark Malstrom on 7/2/19.
//  Copyright © 2019 Mark Malstrom. All rights reserved.
//

import Foundation
import TinyNetworking
#if canImport(Combine)
import Combine
#else
import OpenCombine
#endif

class Authentication {
    private(set) var didChange: AnyPublisher<Token?, Never> = Publishers.Empty().eraseToAnyPublisher()
    let subject = PassthroughSubject<Token?, Never>()
    
    let endpoint = Endpoint<Token>(
        json: .post,
        url: URL(string: "https://authorization.go.com/token")!,
        accept: .json,
        body: "grant_type=assertion&assertion_type=public&client_id=WDPRO-MOBILE.MDX.WDW.ANDROID-PROD"
        .data(using: .utf8)
    )
    
    var firstSubscriber: Bool = true
    
    var token: Token? {
        didSet {
            DispatchQueue.main.async {
                self.subject.send(self.token)
            }
        }
    }
    
    init() {
        didChange = subject.handleEvents(receiveSubscription: { [weak self] sub in
            guard let this = self, this.firstSubscriber else { return }
            this.firstSubscriber = false
            this.reload()
        }).eraseToAnyPublisher()
    }
    
    func reload() {
        if let token = token, token.valid { return }
        URLSession.shared.load(endpoint) { result in
            self.token = try? result.get()
        }
    }
}

extension Authentication {
    struct Token: Decodable {
        /// The access_token for authentication of the Disney API
        let accessToken: String
        
        /// expiresIn is the maximum time the access_token is valid.
        /// It's possible for the token to be given back just moments before
        /// it is invalid. Therefore we should force the ttl value in the
        /// cache lower than this value so requests don't fail.
        private let expires_in: String?
        
        /// Seconds until expiration of the accessToken
        var expiresIn: Int {
            return Int(expires_in ?? "0")!
        }
        
        /// When the authentication was retrieved
        let timeCreated = Date()
        
        /// When a new authentication should be created so the current one doesn't expire during use
        var refreshTime: Date {
            let calendar = Calendar.current
            return calendar.date(byAdding: .second, value: Int(ceil(Double(expiresIn) * 0.9)), to: timeCreated)!
        }
        
        /// If this token is still a valid token or if it needs to be refreshed
        var valid: Bool { refreshTime <= Date() }
        
        private enum CodingKeys: String, CodingKey {
            case accessToken = "access_token"
            case expires_in
        }
    }
}
