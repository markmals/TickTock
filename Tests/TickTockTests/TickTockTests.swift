import XCTest
@testable import TickTock

final class TickTockTests: XCTestCase {
    func testExample() {}

    static var allTests = [
        ("testExample", testExample),
    ]
}

#if canImport(SwiftUI)

import SwiftUI

// https://www.objc.io/blog/2019/06/25/swiftui-data-loading/
@available(iOS 13, macOS 10.15, tvOS 13, watchOS 6, *)
struct ContentView : View {
    let park = Park()
    // FIXME: How do I make this work?
    // How do I properly structure my API so I can use it like this with Combine/SwiftUI?
    // Can't do this, because park.schecule is an async...
    @ObjectBinding var user = Resource(endpoint: park.schedule(for: "disneyland"))
    
    var body: some View {
        Group {
            if user.value == nil {
                Text("Loading...")
            } else {
                VStack {
                    Text(user.value!.startTime).bold()
                    Text(user.value!.endTime)
                }
            }
        }
    }
}

#endif
