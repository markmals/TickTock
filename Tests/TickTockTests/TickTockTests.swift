import XCTest
@testable import TickTock

final class TickTockTests: XCTestCase {
    func testExample() {
        let park = Park(park: .disneyland)
        // Every time the schedule changes, this should update
        park.schedule.didChange.sink { (data) in
            print("Opens at: \(data?.startTime)")
            print("Closes at: \(data?.endTime)")
            print("Schedule type: \(data?.type)")
        }
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}

// Uncomment the following lines to see an example of how I'd like to use this API within SwiftUI:

//#if canImport(SwiftUI)
//
//import SwiftUI
//
//extension Schedule: BindableObject {}
//
//// https://www.objc.io/blog/2019/06/25/swiftui-data-loading/
//@available(iOS 13, macOS 10.15, tvOS 13, watchOS 6, *)
//struct ContentView : View {
//    let park = Park(park: .disneyland)
//    @ObjectBinding var schedule = park.schedule
//
//    var body: some View {
//        Group {
//            if user.value == nil {
//                Text("Loading...")
//            } else {
//                VStack {
//                    Text(schedule.data!.startTime).bold()
//                    Text(schedule.data!.endTime)
//                }
//            }
//        }
//    }
//}
//
//#endif
