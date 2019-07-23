//
//  Utility.swift
//  TickTockCrock
//
//  Created by Mark Malstrom on 7/22/19.
//  Copyright © 2019 Mark Malstrom. All rights reserved.
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
