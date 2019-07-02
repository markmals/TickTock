//
//  Utilities.swift
//  
//
//  Created by Mark Malstrom on 7/2/19.
//

import Foundation

extension Date {
    var iso8601: String {
        return ISO8601DateFormatter().string(from: self)
    }
}

extension Bool {
    var polarity: String {
        return self ? "Yes" : "No"
    }
}
