//
//  URLSessionDataTaskPublisher+validate.swift
//  
//
//  Created by Mark Malstrom on 8/8/19.
//

import Foundation
import Combine

extension URLSession.DataTaskPublisher {
    func validate(for statusCodeRange: Range<Int> = 200..<300) -> AnyPublisher<Data, Error> {
        tryMap { (data: Data, response: URLResponse) -> Data in
            guard let httpResponse = response as? HTTPURLResponse else {
                throw URLError(.unknown)
            }
            
            guard httpResponse.statusCode >= statusCodeRange.min()! && httpResponse.statusCode < statusCodeRange.max()! else {
                throw URLError(.badServerResponse)
                // .wrongStatusCode(statusCode: httpResponse.statusCode, response: httpResponse)
            }
            
            return data
        }
        .eraseToAnyPublisher()
    }
}
