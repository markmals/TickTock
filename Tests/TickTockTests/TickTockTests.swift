import XCTest
import Combine
@testable import TickTock

final class TickTockTests: XCTestCase {
    func testExample() {
        // Every time the schedule changes, this should update
//        cancellable = Park(for: .disneyland).schedulesPublisher
//            // FIXME: Seriously... How does Combine error handling work...?
//            .assertNoFailure()
//            .sink {
//                print("Opens at: \($0.startTime)")
//                print("Closes at: \($0.endTime)")
//                print("Schedule type: \($0.type?.rawValue ?? "Unknown")")
//            }
    }
    
    static var allTests = [
        ("testExample", testExample),
    ]
}

// Uncomment the following lines to see an example of how I'd like to use this API within SwiftUI:

//import SwiftUI
//import Combine
//
//struct TestView: View {
//    @ObservedObject var park = ParkResource(park: .disneyland)
//
//    var body: some View {
//        ZStack {
//            if (park.schedule != nil) && (park.attractions != nil) {
//                Text("Park opens at: \(park.schedule!.startTime)")
//                Text("Park closes at: \(park.schedule!.endTime)")
//                ForEach(park.attractions!) { attraction in
//                    Text("\(attraction.description)")
//                }
//            } else if park.error != nil {
//                Text("Error: \(park.error!.localizedDescription)")
//            }
//        }
//        .onAppear(perform: park.load)
//        .onDisappear(perform: park.cancel)
//    }
//}
//
//#if DEBUG
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        TestView()
//    }
//}
//#endif
