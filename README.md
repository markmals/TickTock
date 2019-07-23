# TickTock

TickTock is a wrapper for Disney's private Theme Parks data API, providing attraction and wait time information and park schedules. If you know of any more data provided by Disney's private API and would like me to add it to TickTock, please open an issue and let me know.

## Installation

Coming soon...

<!---
#### Swift Package Manager

Simply add this line to your `Package.swift` as an element in your package's dependencies:

```swift
.package(url: "https://github.com/markmals/TickTock", from: "1.0.0"),
```

Or, if you want to use this framework in an Apple-platform app, you can go to `File > New` in Xcode and select `Swift Package`. More info on that approach can be found at [WWDC by Sundell](https://wwdcbysundell.com/2019/xcode-swiftpm-first-look/).
-->

## Usage

Make sure to import your modules first:

```swift
import SwiftUI
import Combine // or `import OpenCombine` on non-Apple platforms
import TickTock
```

You can see an example of how to fetch the data in [the TickTock tests](/Tests/TickTockTests/TickTockTests.swift). With [a simple class and extension](https://stackoverflow.com/a/56720433) to make Combine Publishers play nicely with SwiftUI:

```swift
class BindableObjectPublisher<PublisherType: Publisher>: BindableObject where PublisherType.Failure == Never {
    typealias Data = PublisherType.Output

    var willChange: PublisherType
    var data: Data?

    init(willChange: PublisherType) {
        self.willChange = willChange
        _ = self.willChange.sink { (value) in
            self.data = value
        }
    }
}

extension Publisher where Failure == Never {
    func bindableObject() -> BindableObjectPublisher<Self> {
        return BindableObjectPublisher(willChange: self)
    }
}
```

Then we can begin to use `Park`'s Publishers in a SwiftUI app:

```swift
struct ContentView: View {
    @ObjectBinding var schedules = Park(for: .disneyland).schedulesPublisher
        // Still not sure how to gracefully handle failure and display an `Alert()`
        .assertNoFailure()
        .bindableObject()

    var body: some View {
        Group {
            if schedules.data == nil {
                Text("Loading...")
            } else {
                VStack {
                    Text("The park opens at: \(schedules.data!.startTime)")
                    Text("The park closes at: \(schedules.data!.endTime)")
                }
            }
        }
    }
}
```

## Attribution

Discovery of this API, it's various endpoints, and authentication methods originated with [cubehouse](https://github.com/cubehouse/)'s excellent [`themeparks`](https://github.com/cubehouse/themeparks) JavaScript library.
