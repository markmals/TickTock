//
//  Schedule.swift
//  TickTock
//
//  Created by Mark Malstrom on 7/2/19.
//  Copyright © 2019 Mark Malstrom. All rights reserved.
//

import Foundation
import TinyNetworking
#if !os(iOS) && !os(macOS) && !os(tvOS) && !os(watchOS)
import OpenCombine
#elseif
import Combine
#endif

class Schedule {
    private let url: URL
    private var endpointDidChange: AnyPublisher<Endpoint<Schedule.Data>?, Never> = Publishers.Empty().eraseToAnyPublisher()
    private let endpointSubject = PassthroughSubject<Endpoint<Schedule.Data>?, Never>()
    private var firstEndpointSubscriber: Bool = true
    
    private var endpoint: Endpoint<Schedule.Data>? {
        didSet {
            DispatchQueue.main.async {
                self.endpointSubject.send(self.endpoint)
            }
        }
    }
    
    private(set) var didChange: AnyPublisher<Schedule.Data?, Never> = Publishers.Empty().eraseToAnyPublisher()
    let subject = PassthroughSubject<Schedule.Data?, Never>()
    
    var firstSubscriber: Bool = true
    
    var data: Schedule.Data? {
        didSet {
            DispatchQueue.main.async {
                self.subject.send(self.data)
            }
        }
    }
    
    init(for id: String) {
        url = URL(string: "https://api.wdpro.disney.go.com/global-pool-override-A/facility-service/schedules/\(id)")!
        
        didChange = subject.handleEvents(receiveSubscription: { [weak self] sub in
            guard let this = self, this.firstSubscriber else { return }
            this.firstSubscriber = false
            this.reload()
        }).eraseToAnyPublisher()
        
        endpointDidChange = endpointSubject.handleEvents(receiveSubscription: { [weak self] sub in
            guard let this = self, this.firstEndpointSubscriber else { return }
            this.firstEndpointSubscriber = false
            this.reloadEndpoint()
        }).eraseToAnyPublisher()
    }
    
    func reload() {
        reloadEndpoint()
        let _ = endpointDidChange
            .compactMap({ $0 })
            // Seems like there should be a better way to do this...
            // Maybe with a map of somesort, if I use the URLSession publisher...?
            .sink { (endpoint) in
                URLSession.shared.load(endpoint) { result in
                    self.data = try? result.get()
                }
            }
    }
    
    private func reloadEndpoint() {
        Park.authentication.reload()
        // FIXME: This will not notify and update/create a new endpoint if the authentication is cached
        let _ = Park.authentication.didChange
            .compactMap({ $0?.accessToken })
            .map({ Park.endpoint(url: self.url, accessToken: $0) })
            .assign(to: \Schedule.endpoint, on: self)
    }
}

extension Schedule {
    struct Data: Decodable {
        public enum ScheduleType: String, Codable {
            case extraMagicMorning = "Extra Magic Hour and Magic Morning"
            case extraMagicHours = "Extra Magic Hours"
            case operating = "Operating"
            case specialEvent = "Special Ticketed Event"
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
        public let type: Schedule.Data.ScheduleType?
        
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
            self.type = try container.decode(Schedule.Data.ScheduleType.self, forKey: .type)
        }
    }
}

extension Schedule.Data: CustomStringConvertible {
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
        
        //For date: \(date.iso8601)
        return """
        Schedule type: \(type?.rawValue ?? "Unavaliable")
        
        \(starts): \(startTime)
        \(ends): \(endTime)
        """
    }
}
