//
//  ParkResource.swift
//  TickTock
//
//  Created by Mark Malstrom on 8/6/19.
//  Copyright © 2019 Mark Malstrom. All rights reserved.
//

import Foundation
import Combine

/// A class to coordinate the fetching of all of the TickTock model objects
public final class ParkResource: ObservableObject {
    private let park: Park
    private var cancellable: AnyCancellable? = nil
    
    // FIXME: Work on token storage and caching
    // @Published private var token: Result<Token, Error>? = nil
    @Published public private(set) var schedule: Result<Schedule, Error>? = nil
    @Published public private(set) var attractions: Result<[Attraction], Error>? = nil
    
    public init(park: Park) {
        self.park = park
    }
    
    deinit {
        cancel()
    }
    
    static func publisher<Item: Decodable>(for request: URLRequest, type: Item.Type) -> AnyPublisher<Item, Error> {
        URLSession.shared
            .dataTaskPublisher(for: request)
            .validate()
            // TODO: Figure out how to add dependency injection for a custom decoder
            // Can't use TopLevelDecoder as a type constraint b/c of associated types
            .decode(type: type, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func attractionsPublisher(with token: Token) -> AnyPublisher<[Attraction], Error> {
        ParkResource.publisher(for: Attraction.request(for: park.id, with: token), type: [Attraction].self)
    }
    
    func schedulesPublisher(with token: Token) -> AnyPublisher<Schedule, Error> {
        ParkResource.publisher(for: Schedule.request(for: park.id, with: token), type: Schedule.self)
    }
    
    static func tokenPublisher() -> AnyPublisher<Token, Error> {
        ParkResource.publisher(for: Token.request, type: Token.self)
    }
    
    public func loadAttractions() {
        cancellable = ParkResource.tokenPublisher()
            .flatMap {
                self.attractionsPublisher(with: $0)
            }
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case let .failure(error) = completion {
                        self?.attractions = .failure(error)
                    }
                },
                receiveValue: { [weak self] attractions in
                    self?.attractions = .success(attractions)
                }
            )
    }
    
    public func loadSchedule() {
        cancellable = ParkResource.tokenPublisher()
            .flatMap {
                self.schedulesPublisher(with: $0)
            }
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case let .failure(error) = completion {
                        self?.schedule = .failure(error)
                    }
                },
                receiveValue: { [weak self] schedule in
                    self?.schedule = .success(schedule)
                }
            )
    }
    
    public func load() {
        cancellable = ParkResource.tokenPublisher()
            .flatMap {
                Publishers.CombineLatest(
                    self.attractionsPublisher(with: $0),
                    self.schedulesPublisher(with: $0)
                )
            }
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case let .failure(error) = completion {
                        self?.schedule = .failure(error)
                        self?.attractions = .failure(error)
                    }
                },
                receiveValue: { [weak self] (attractions, schedule) in
                    self?.attractions = .success(attractions)
                    self?.schedule = .success(schedule)
                }
            )
    }
    
    public func cancel() {
        cancellable?.cancel()
    }
}
