//
//  SwiftUISupport.swift
//  
//
//  Created by Mark Malstrom on 7/2/19.
//
// https://www.objc.io/blog/2019/06/25/swiftui-data-loading/

import Foundation
import TinyNetworking

#if canImport(SwiftUI) && canImport(Combine)

import SwiftUI
import Combine

@available(iOS 13, macOS 10.15, tvOS 13, watchOS 6, *)
public final class Resource<A>: BindableObject {
    public let didChange = PassthroughSubject<A?, Never>()
    let endpoint: Endpoint<A>
    
    var value: A? {
        didSet {
            DispatchQueue.main.async {
                self.didChange.send(self.value)
            }
        }
    }
    
    init(endpoint: Endpoint<A>) {
        self.endpoint = endpoint
        reload()
    }
    
    func reload() {
        URLSession.shared.load(endpoint) { result in
            self.value = try? result.get()
        }
    }
}

#endif
