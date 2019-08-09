//
//  Authentication.swift
//  TickTockCrock
//
//  Created by Mark Malstrom on 7/22/19.
//  Copyright © 2019 Mark Malstrom. All rights reserved.
//

import Foundation

struct Token: Decodable {
    static let request = URLRequest(
        url: URL(string: "https://authorization.go.com/token"),
        method: .post,
        accept: .json,
        body: "grant_type=assertion&assertion_type=public&client_id=WDPRO-MOBILE.MDX.WDW.ANDROID-PROD"
    )
    
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
    
    init() {
        accessToken = ""
        expires_in = nil
    }
    
    private enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case expires_in
    }
}
