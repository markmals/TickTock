//
//  Date+iso8601.swift
//  
//
//  Created by Mark Malstrom on 8/8/19.
//

import Foundation

extension Date {
    var iso8601: String {
        return ISO8601DateFormatter().string(from: self)
    }
}
