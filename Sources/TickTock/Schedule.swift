//
//  Schedule.swift
//  
//
//  Created by Mark Malstrom on 7/1/19.
//

import Foundation

extension Park {
    public struct Schedule {
        public enum ScheduleType: String, Codable {
            case extraMagicMorning = "Extra Magic Hour and Magic Morning"
            case extraMagicHours = "Extra Magic Hours"
            case operating = "Operating"
            case specialEvent = "Special Ticketed Event"
            // FIXME: What to do with this???
            case closed = "Closed"
        }
        
        enum Error: Swift.Error {
            case unableToGetParkOpeningTime
        }
        
        /// The date when the schedule is active
        public let date: Date
        /// The start time
        public let startTime: String
        /// The end time
        public let endTime: String
        /// The type/name
        public let type: Schedule.ScheduleType?
    }
}

extension Park.Schedule: Decodable {
    private enum CodingKeys: String, CodingKey {
        case date
        case startTime
        case endTime
        case type
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let dateString: String = try container.decode(String.self, forKey: .date)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        // FIXME: Don't force unwrap this
        self.date = dateFormatter.date(from: dateString)!
        self.startTime = try container.decode(String.self, forKey: .startTime)
        self.endTime = try container.decode(String.self, forKey: .endTime)
        self.type = try container.decode(Park.Schedule.ScheduleType.self, forKey: .type)
    }
}

extension Park.Schedule: CustomStringConvertible {
    public var description: String {
        var starts = "Starts on"
        var ends = "Ends on"
        
        if let tp = type {
            switch tp {
            case .operating:
                starts = "Opens at"
                ends = "Closes at"
            case .closed:
                starts = "Closed on"
                ends = "Closed on"
            default: break
            }
        }
        
        return """
        Schedule type: \(type?.rawValue ?? "Unavaliable")
        For date: \(date.iso8601)
        \(starts): \(startTime)
        \(ends): \(endTime)
        """
    }
}

extension Sequence where Iterator.Element == Park.Schedule {
    /// The first `.operating` startTime in the array
    public var parkOpeningTime: String? {
        for schedule in self {
            if schedule.type == .operating {
                return schedule.startTime
            }
        }
        
        return nil
    }
    
    /// The first `.operating` date in the array
    public var parkOpeningDate: Date? {
        for schedule in self {
            if schedule.type == .operating {
                return schedule.date
            }
        }
        
        return nil
    }
}
