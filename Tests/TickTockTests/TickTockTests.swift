import XCTest
@testable import TickTock

final class TickTockTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(TickTock().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
