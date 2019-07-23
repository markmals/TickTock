import XCTest
import Combine
@testable import TickTock

final class TickTockTests: XCTestCase {
    var cancellable: Cancellable? = nil
    
    func testExample() {
        // Every time the schedule changes, this should update
        cancellable = Park(for: .disneyland).schedulesPublisher
            // FIXME: Seriously... How does Combine error handling work...?
            .assertNoFailure()
            .sink {
                print("Opens at: \($0.startTime)")
                print("Closes at: \($0.endTime)")
                print("Schedule type: \($0.type?.rawValue ?? "Unknown")")
            }
    }
    
    override func tearDown() {
        cancellable?.cancel()
    }
        
    static var allTests = [
        ("testExample", testExample),
    ]
}

// Uncomment the following lines to see an example of how I'd like to use this API within SwiftUI:

//import SwiftUI
//import Combine
//
//class BindableObjectPublisher<PublisherType: Publisher>: BindableObject where PublisherType.Failure == Never {
//    typealias Data = PublisherType.Output
//
//    var willChange: PublisherType
//    var data: Data?
//
//    init(willChange: PublisherType) {
//        self.willChange = willChange
//        _ = self.willChange.sink { (value) in
//            self.data = value
//        }
//    }
//}
//
//extension Publisher where Failure == Never {
//    func bindableObject() -> BindableObjectPublisher<Self> {
//        return BindableObjectPublisher(willChange: self)
//    }
//}
//
//
//struct ContentView: View {
//    @ObjectBinding var schedules = Park(for: .disneyland).schedulesPublisher
//        .assertNoFailure()
//        .bindableObject()
//
//    var body: some View {
//        Text("The park opens at: \(schedules.data?.startTime ?? "0:00")")
//    }
//}
//
//#if DEBUG
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
//#endif
