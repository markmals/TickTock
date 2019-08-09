//
//  URLRequest+init.swift
//  TickTock
//
//  Created by Mark Malstrom on 8/8/19.
//

import Foundation

extension URLRequest {
    public enum AcceptType: String {
        case json
        case xml
        
        var identifier: String {
            return "application/\(rawValue)"
        }
    }
    
    public enum HTTPMethod: String {
        case get
        case post
        case delete
        case head
        case put
        case connect
        case options
        case trace
        case patch
        
        var identifier: String {
            return rawValue.uppercased()
        }
    }
    
    public init(url: URL?, method: HTTPMethod, accept: AcceptType, headerFields: [String: String]? = nil, body: String?) {
        self.init(url: url!)
        allHTTPHeaderFields = headerFields
        setValue(accept.identifier, forHTTPHeaderField: "Accept")
        httpMethod = method.identifier
        httpBody = body?.data(using: .utf8)
    }
}
